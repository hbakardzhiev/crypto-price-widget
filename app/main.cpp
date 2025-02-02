#include "FL/Fl.H"
#include "FL/Fl_Button.H"
#include "FL/Fl_Text_Buffer.H"
#include "FL/Fl_Text_Display.H"
#include "atomic"
#include "future"
#include <FL/Enumerations.H>
#include <FL/Fl_Widget.H>
#include <FL/Fl_Window.H>
#include <cstdlib>
#include <functional>

auto text = new Fl_Text_Buffer();

void whenPushed(Fl_Widget *, void *) { printf("Clicked\n"); }
void exitWhenPushed(Fl_Widget *, void *) { exit(0); }
void setTextWhenActivated() {}

int main() {
  auto window = new Fl_Window(0, 0, 300, 300);
  auto button = new Fl_Button(0, 0, 100, 40, "Click ME");
  auto exitButton = new Fl_Button(100, 0, 100, 40, "Exit");
  auto textDisplay = new Fl_Text_Display(0, 40, 150, 50);

  textDisplay->buffer(text);

  text->text("This is a test");

  std::atomic<bool> stopFlag(false); // A flag to stop the timer

  // Launch the repeating timer in another thread
  auto future = std::async(std::launch::async, repeatingTimer, callback, 5000,
                           std::ref(stopFlag));

  // auto textView = new FL_Text
  //
  button->callback(whenPushed);
  exitButton->callback(exitWhenPushed);

  window->add(button);

  window->end();
  window->show();
  return Fl::run();
}
