class TimerForPython < Formula
    name "timer-for-python"
    desc "Timer for Python makes it easy for beginners and experts to measure how much time it takes to run Python programs and gauge performance of multiple, smaller bits of code."
    homepage "https://github.com/jakob-bagterp/timer_for_python"
    url "https://github.com/jakob-bagterp/timer_for_python/releases/download/v0.3.3/timer_for_python-0.3.3.tar.gz"
    sha256 "71f49d1b98fb05dbc572a34c2edf1411fbf42ab4ba0063e2bf7c9cb36cf38d98"
    license "MIT"

    depends_on "python@3.8" => :optional

    def install
        bin.install "timer-for-python"
    end
end
