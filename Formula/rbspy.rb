class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.3.11.tar.gz"
  sha256 "4e2dc89b73bb59c91d07842a4e318a6661a50fbae8906f3d5cb8888d51b99f11"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a10933e0d91454ad97322d652f252af02a160820557afc9d1f5a46477d1ab6ac" => :big_sur
    sha256 "217244ca6e6ab565de859dfa7c2b4f36a37c7809c33ae69af5890008abbe8d38" => :catalina
    sha256 "99c94b9554baef714aabdbf73a0e6f9e7991e3c744fb108bda6643d81b10eeec" => :mojave
    sha256 "613087ac87eb99251be1bc99ee843e043bf19f4c921e6ace169570d54faa4833" => :high_sierra
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
