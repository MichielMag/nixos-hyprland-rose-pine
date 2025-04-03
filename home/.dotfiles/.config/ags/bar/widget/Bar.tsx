import { App, Astal, Gtk, Gdk } from 'astal/gtk3';
import { Variable, bind } from 'astal';
import Hyprland from 'gi://AstalHyprland';

const time = Variable('').poll(1000, 'date');
const hypr = Hyprland.get_default();
export default function Bar(gdkmonitor: Gdk.Monitor) {
	const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;
	const clientBind = bind(hypr, 'focused_client');
	const titleBind = clientBind.as(client => {
		console.log('client changed', client);
		return client.title;
	});
	const title = Variable('').bind(titleBind);

	return (
		<window
			className="Bar"
			gdkmonitor={gdkmonitor}
			exclusivity={Astal.Exclusivity.EXCLUSIVE}
			anchor={TOP | LEFT | RIGHT}
			application={App}
		>
			<centerbox>
				<div className="title" label={title} />
				<button onClicked="echo hello" halign={Gtk.Align.CENTER}>
					<label label={titleBind} />
				</button>
				<button
					onClicked={() => print('hello')}
					halign={Gtk.Align.CENTER}
				>
					<label label={time()} />
				</button>
			</centerbox>
		</window>
	);
}
