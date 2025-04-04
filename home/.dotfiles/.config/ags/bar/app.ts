import { App } from 'astal/gtk3';
import style from './style.scss';
import Bar from './widget/Bar';

App.start({
	requestHandler(request: string, res: (response: any) => void) {
		if (request === 'hide') {
			res('Hiding the bar');
		}
		if (request === 'show') {
			res('Showing the bar');
		}
	},
	css: style,
	main() {
		App.get_monitors().map(Bar);
	},
});
