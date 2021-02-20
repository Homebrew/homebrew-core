class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.3.12.tar.gz"
  sha256 "4595d6c5706f755bc39c6cfb5aeae68ae6b1d8d3ce1768780d76294458cbe4df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "4f7f7e4aa0ec94ef99313272c2d809c7824fada06b4223d401f98649a0cba037"
    sha256 cellar: :any_skip_relocation, catalina: "b2a6a2d08d0ca8809e4c3fddb47d043645971cb7a1e5607afddfefd80cd15522"
    sha256 cellar: :any_skip_relocation, mojave:   "b46ddc1be41ebabebf7b201f91457d187f8413c394b26327cd03a2e85d54902d"
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
