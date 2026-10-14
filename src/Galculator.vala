enum Operator {
	Plus,
	Minus,
	Times,
	Divide,
	Count, // sentinel
	Noop,
}

const string [] op_labels = {"+", "-", "×", "÷"};


public class Galculator : Gtk.Application {
	bool is_computed = false;
	Operator last_op = Operator.Noop;

	public override void activate () {
		var win = new Gtk.ApplicationWindow (this);
		win.title = "Galculator";
		var grid = new Gtk.Grid ();

		var operator = new Gtk.Label ("");
		var accurate = new Gtk.Label ("");
		var current  = new Gtk.Label ("");
		var num_btns = new Gtk.Button[10];

		num_btns[0] = new Gtk.Button.with_label ("0");
		grid.attach (num_btns[0], 0, 3, 3);

		for (var row = 0; row < 3; row++) {
			for (var col = 0; col < 3; col++) {
				var idx = row * 3 + col + 1, label = idx.to_string ();
				num_btns[idx] = new Gtk.Button.with_label (label);
				grid.attach (num_btns[idx], col, 2 - row);
			}
		}

		for (var idx = 0; idx < 10; idx++) {
			var label = idx.to_string ();
			num_btns[idx].clicked.connect (() => {
				if (this.is_computed)
					accurate.label = label;
				else if (this.last_op == Operator.Noop)
					accurate.label += label;
				else
					current.label += label;
				this.is_computed = false;
			});
		}

		var op_btns = new Gtk.Button[Operator.Count];

		for (var idx = 0; idx < Operator.Count; idx++) {
			var op = (Operator)idx, label = op_labels[op];
			op_btns[idx] = new Gtk.Button.with_label (label);
			op_btns[idx].clicked.connect (() => {
				operator.label   = label;
				this.last_op     = op;
				this.is_computed = false;
			});
			grid.attach (op_btns[idx], 3, idx);
		}

		var compute = new Gtk.Button.with_label ("=");

		compute.clicked.connect (() => {
			var lhs = int.parse (accurate.label);
			var rhs = int.parse (current.label);
			switch (this.last_op) {
				case Operator.Plus:   lhs += rhs; break;
				case Operator.Minus:  lhs -= rhs; break;
				case Operator.Times:  lhs *= rhs; break;
				case Operator.Divide: lhs /= rhs; break;
				default: assert_not_reached ();
			}
			accurate.label   = lhs.to_string ();
			operator.label   = current.label = "";
			this.last_op     = Operator.Noop;
			this.is_computed = true;
		});

		grid.attach (accurate, 0, -2, 3);
		grid.attach (current,  0, -1, 3);
		grid.attach (operator, 3, -2);
		grid.attach (compute,  3, -1);

		win.child = grid;
		win.present ();
	}

	public static int main (string [] args) {
		var app = new Galculator ();
		return app.run (args);
	}
}
