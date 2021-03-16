class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.3.14.tar.gz"
  sha256 "0df6ff6f5bbd47727d9925092ff151d5bcfa33b1989cb4e7178c4d7a436b971f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "215df3cc59e386f95ba3b44cf713bbbbd3d6e2684df9832f391aad32ef5e375d"
    sha256 cellar: :any_skip_relocation, catalina: "651ac4f3e6e2d595cf1d1543b7bec4050b573008dd511de12206013122934aaf"
    sha256 cellar: :any_skip_relocation, mojave:   "9844ce8b23eb75f3ae6076fe7d207feb0fa59dbbab9e9f1b8b378e2e1dc36096"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    recording = <<~EOS
      H4sICCOlhlsAA2JyZXdfdGVzdF9yZXN1bHQAvdHBCsIwDAbgu08hOQ/nHKgM8S08iYy0Vlds0
      5J2Dhl7d3eZTNxN8Rb4yf9BwiL4xzKbtRAZpYLi2AKh7QfYyfmlJhm1oz0kwMpg1HdVeoxVH9
      d0I9dQn6AIztRxSKg2JgGjSZGDYtklr0ZEnCgKleNYenZXRrtg8dkI6SEoDmnlrEoFqyYNaL1
      R70uDuBqJQogpcWL7K3I9IqWU/yCz8WF3FvXkk37P5t0pAa/PUOTbfLvpZk/I+tcWQgIAAA==
    EOS

    (testpath/"recording.gz").write Base64.decode64(recording.delete("\n"))
    system "#{bin}/rbspy", "report", "-f", "summary", "-i", "recording.gz",
                           "-o", "result"

    expected_result = "100.00   100.00  aaa - short_program.rb"
    assert_includes File.read("result"), expected_result
  end
end
