/* main.vala
 *
 * Copyright 2018 Dezeiraud
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE X CONSORTIUM BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * Except as contained in this notice, the name(s) of the above copyright
 * holders shall not be used in advertising or otherwise to promote the sale,
 * use or other dealings in this Software without prior written
 * authorization.
 */

namespace Calculator {

    enum Operators {
        NONE,
        PLUS,
        SUBTRACT,
        MULTIPLY,
        DIVIDE
    }

    public class Window : Gtk.ApplicationWindow
    {
        // Variables
        private bool _firstOperator = true;
        private Operators _lastOperator = Operators.NONE;
        private double _currentResult = 0;
        private bool _refresh = true;

        // Gtk
        private Gtk.Entry _output = new Gtk.Entry ();
        private Gtk.Button _button_reset = new Gtk.Button.with_label("AC");

	    internal Window (Gtk.Application app)
	    {
		    Object (application: app, title: "Calculator");
		    this.set_resizable (false);

            setup_ui ();
	    }

	    private void setup_ui()
	    {
	        // buttons
            var button_reverse = new Gtk.Button.with_label("+/-");
            var button_percentage = new Gtk.Button.with_label("%");
            var button_divide = new Gtk.Button.with_label("÷");
            var button_multiply = new Gtk.Button.with_label("×");
            var button_subtract = new Gtk.Button.with_label("-");
            var button_plus = new Gtk.Button.with_label("+");
            var button_equal = new Gtk.Button.with_label("=");
            var button_comma = new Gtk.Button.with_label(",");

            var button_0 = new Gtk.Button.with_label("0");
            var button_1 = new Gtk.Button.with_label("1");
            var button_2 = new Gtk.Button.with_label("2");
            var button_3 = new Gtk.Button.with_label("3");
            var button_4 = new Gtk.Button.with_label("4");
            var button_5 = new Gtk.Button.with_label("5");
            var button_6 = new Gtk.Button.with_label("6");
            var button_7 = new Gtk.Button.with_label("7");
            var button_8 = new Gtk.Button.with_label("8");
            var button_9 = new Gtk.Button.with_label("9");

	        // layout
	        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 3);

            _output.editable = false;
            _output.xalign = 1; // Align to right

	        var grid = new Gtk.Grid ();
            grid.margin = 6;
            grid.set_column_spacing(4);
            grid.set_row_spacing(4);
            grid.set_row_homogeneous (true);

            grid.attach(_button_reset, 0, 0, 1, 1);
            grid.attach(button_reverse, 1, 0, 1, 1);
            grid.attach(button_percentage, 2, 0, 1, 1);
            grid.attach(button_divide, 3, 0, 1, 1);

            grid.attach(button_7, 0, 1, 1, 1);
            grid.attach(button_8, 1, 1, 1, 1);
            grid.attach(button_9, 2, 1, 1, 1);
            grid.attach(button_multiply, 3, 1, 1, 1);

            grid.attach(button_4, 0, 2, 1, 1);
            grid.attach(button_5, 1, 2, 1, 1);
            grid.attach(button_6, 2, 2, 1, 1);
            grid.attach(button_subtract, 3, 2, 1, 1);

            grid.attach(button_1, 0, 3, 1, 1);
            grid.attach(button_2, 1, 3, 1, 1);
            grid.attach(button_3, 2, 3, 1, 1);
            grid.attach(button_plus, 3, 3, 1, 1);

            grid.attach(button_0, 0, 4, 2, 1);
            grid.attach(button_comma, 2, 4, 1, 1);
            grid.attach(button_equal, 3, 4, 1, 1);

            box.add (_output);
            box.add (grid);
		    this.add(box);

		    // actions
		    _button_reset.clicked.connect (() => {
		        if(_lastOperator == Operators.NONE) {
		            _firstOperator = true;
                    _lastOperator = Operators.NONE;
                    _currentResult = 0;
                    _refresh = true;
                    _output.set_text ("0");
                    _button_reset.label = "AC";
		        }
		        else {
		            _output.set_text ("");
		            _button_reset.label = "AC";
		        }
            });

            button_percentage.clicked.connect (() => {
                _output.set_text ((double.parse(_output.get_text ()) / 100).to_string ());
            });

            button_plus.clicked.connect (() => {
                clear_entry_operator ();
                _currentResult += double.parse(_output.get_text ());
                _refresh = true;
                _lastOperator = Operators.PLUS;
                _output.set_text (_currentResult.to_string ());
            });

            button_subtract.clicked.connect (() => {
                clear_entry_operator ();

                if(_firstOperator) {
                    _currentResult += double.parse(_output.get_text ());
                    _firstOperator = false;
                }
                else
                    _currentResult -= double.parse(_output.get_text ());

                _refresh = true;
                _lastOperator = Operators.SUBTRACT;
                _output.set_text (_currentResult.to_string ());
            });

            button_multiply.clicked.connect (() => {
                clear_entry_operator ();

                if(_firstOperator) {
                    _currentResult += double.parse(_output.get_text ());
                    _firstOperator = false;
                }
                else if (_lastOperator != Operators.NONE)
                    _currentResult *= double.parse(_output.get_text ());

                _refresh = true;
                _lastOperator = Operators.MULTIPLY;
                _output.set_text (_currentResult.to_string ());
            });

            button_divide.clicked.connect (() => {
                clear_entry_operator ();
                var currentNumber = double.parse(_output.get_text ());

                if(_firstOperator) {
                    _currentResult += currentNumber;
                    _firstOperator = false;
                }
                else if (_lastOperator != Operators.NONE) {
                    if (currentNumber == 0)
                        _output.set_text ("Not a number");
                    else {
                        _currentResult /= currentNumber;
                        _output.set_text (_currentResult.to_string ());
                    }
                }
                else
                    _output.set_text (_currentResult.to_string ());

                _refresh = true;
                _lastOperator = Operators.DIVIDE;
            });

            button_equal.clicked.connect (() => {
                switch (_lastOperator) {
                    case Operators.PLUS:
                        _currentResult += double.parse(_output.get_text ());
                        break;
                    case Operators.SUBTRACT:
                        _currentResult -= double.parse(_output.get_text ());
                        break;
                    case Operators.MULTIPLY:
                        _currentResult *= double.parse(_output.get_text ());
                        break;
                    case Operators.DIVIDE:
                        var currentNumber = double.parse(_output.get_text ());
                        if (currentNumber == 0) {
                            _output.set_text ("Not a number");
                            return;
                        }
                        else {
                            _currentResult /= double.parse(_output.get_text ());
                        }
                        break;
                }

                _lastOperator = Operators.NONE;
                _output.set_text (_currentResult.to_string ());
                _refresh = true;
            });

            button_reverse.clicked.connect (() => {
                clear_entry ();
                var builder = new StringBuilder (_output.get_text ());

                if (builder.str.substring (0, 1) == "-")
                    builder.erase (0, 1);
                else
                    builder.prepend_unichar('-');

                _output.set_text (builder.str);
            });

            button_0.clicked.connect (() => { clear_entry (); _output.set_text (_output.get_text () + "0"); });
            button_1.clicked.connect (() => { clear_entry (); _output.set_text (_output.get_text () + "1"); });
            button_2.clicked.connect (() => { clear_entry (); _output.set_text (_output.get_text () + "2"); });
            button_3.clicked.connect (() => { clear_entry (); _output.set_text (_output.get_text () + "3"); });
            button_4.clicked.connect (() => { clear_entry (); _output.set_text (_output.get_text () + "4"); });
            button_5.clicked.connect (() => { clear_entry (); _output.set_text (_output.get_text () + "5"); });
            button_6.clicked.connect (() => { clear_entry (); _output.set_text (_output.get_text () + "6"); });
            button_7.clicked.connect (() => { clear_entry (); _output.set_text (_output.get_text () + "7"); });
            button_8.clicked.connect (() => { clear_entry (); _output.set_text (_output.get_text () + "8"); });
            button_9.clicked.connect (() => { clear_entry (); _output.set_text (_output.get_text () + "9"); });
	        button_comma.clicked.connect (() => { clear_entry (); _output.set_text (_output.get_text () + "."); });
	    }

	    private void clear_entry () {;
            if(_refresh) {
		        _refresh = false;
		        _output.set_text ("");
		         _button_reset.label = "C";
		    }
        }

        private void clear_entry_operator () {
            if(_refresh && _lastOperator == Operators.NONE) {
		        _refresh = false;
		        _output.set_text ("");
		    }
        }
    }
}
