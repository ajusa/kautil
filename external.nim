include karax / prelude
import karax/kdom
import tables
import jsffi
var frappe {.importc, nodecl.}: JsObject
var console {.importc, nodecl.}: JsObject
type Task = object
    id: int
    text: string
    children: seq[Task]
type TaskView = ref object
    focus: bool
var data = js{
    data: js{
        labels: ["12am-3am".kstring, "3am-6am", "6am-9am", "9am-12pm", "12pm-3pm", "3pm-6pm", "6pm-9pm", "9pm-12am"],
        datasets: [js{
            name: "Some Data".kstring,
            chartType: "bar".kstring,
            values: [25, 40, 30, 35, 8, 52, 17, -4]
        }],
    },
    colors: ["purple".kstring, "#ffa3ef", "light-blue"],
}
var rootTask = Task(id: 0, text: "asdf", children: @[
    Task(id: 1, text: "anotha one", children: @[]),
    Task(id: 2, text: "anotha two", children: @[])
])
var state = initTable[int, TaskView]()
proc render(task: var Task): VNode =
    var this = state.getOrDefault(task.id, TaskView())
    state[task.id] = this
    buildHtml(tdiv):
        if this.focus:
            input(setFocus = true, value = task.text):
                proc onblur() =
                    this.focus = false
                proc onchange(e: Event, n: VNode) =
                    task.text = $n.value
                proc onkeydown(e: Event, n: VNode) =
                    echo ((KeyboardEvent)e).keyCode
        else:
            tdiv:
                text task.text
                proc onclick() =
                    discard frappe.Chart(kdom.getElementById("chart"), data).jsNew
                    this.focus = true
        tdiv(class="ml2"):
            for child in task.children.mitems:
                child.render()
proc createDom(): VNode =
    buildHtml(tdiv(class="mh3 mt2")):
        rootTask.render
        tdiv(id="chart")
setRenderer createDom
setForeignNodeId("chart")
