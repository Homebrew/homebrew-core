class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.3.11.tar.gz"
  sha256 "4e2dc89b73bb59c91d07842a4e318a6661a50fbae8906f3d5cb8888d51b99f11"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c1cf783482e2b510aaff073a82ab4858b01feaa5327cc3f8666ca2cf2ea3756" => :catalina
    sha256 "e0867eac5b9f432fa1218271c1f4ced724e23c99e79d6692e127cb07aaafbe91" => :mojave
    sha256 "64e1e766071f1d8155011465545d66e78a20fc5fa0fb164a98c885eb3e452882" => :high_sierra
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
