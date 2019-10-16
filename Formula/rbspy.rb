class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.3.7.tar.gz"
  sha256 "cc9262eec63e8fbb24f2926f27afee20c7cd9695fefad0804dc0272c99b410b8"

  bottle do
    cellar :any_skip_relocation
    sha256 "02a16fda6dca2051b23e8dabe926a64387079ceba01258d23439c100796e3d9f" => :catalina
    sha256 "7bb64a208e7baaa6e1e14a0be8817090a25dfe4b00aa0e01609147c467195e5f" => :mojave
    sha256 "b161ddfff4af3be60659bdcee9661c32731cfd7dad5d4017e419b18d5b6b2cb9" => :high_sierra
    sha256 "53e502d8f8c9a788aae1afa31004114da78f12033f9456ee292fa6e7d3db319a" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
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
