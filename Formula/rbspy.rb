class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.3.13.tar.gz"
  sha256 "f112ee0c309da6d0a7249a6798fbace7c4a77bd5c774acb972804e349e7aa068"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "ab11fef9403b92d3743bcab646f60844761a34d88bdd8cfaae57af353ef83991"
    sha256 cellar: :any_skip_relocation, catalina: "35bea7ddcf3271b2fdcd479290625c9e9a5ea4f139c32f289d3326f03b3e2f21"
    sha256 cellar: :any_skip_relocation, mojave:   "cbe5166fd62c40bd85910497a353be5b49aee4910db6ab740c61e49774e44b80"
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
