class RunOne < Formula
  desc "Run one instance of a unique combination of command and args at a time"
  homepage "https://launchpad.net/run-one"
  url "https://github.com/datamade/run-one/archive/ea3d7744043bf737aa52c3093f068a49b7621d02.tar.gz"
  version "1.18"
  sha256 "8094b26db3efca2a419737ab26d1926e98c116d9e687dc32cd841192c3192dfc"
  depends_on "flock"

  def install
    bin.install "run-one",
                "run-this-one",
                "run-one-constantly",
                "keep-one-running",
                "run-one-until-failure",
                "run-one-until-success"
    man1.install "run-one.1"
  end

  test do
    assert_equal "0", shell_output("#{bin}/run-one-until-success true && echo $?").strip
    assert_equal "0", shell_output("#{bin}/run-one-until-failure false && echo $?").strip
  end
end
