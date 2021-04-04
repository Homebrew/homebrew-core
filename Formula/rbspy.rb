class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.4.2.tar.gz"
  sha256 "4bd76a63db015401124031929ea7138a2625cb6da6300df45dea491e96046cdc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "4baf01d5246bc1bbddd9f8854c1c104c3351c6615fca4cd330fe82f37e86b412"
    sha256 cellar: :any_skip_relocation, catalina: "96201481303eccc9cee8714115590fb6db6f465b7f87f7e5a28e3f691dfdaeb4"
    sha256 cellar: :any_skip_relocation, mojave:   "0a9a0b5f06b56374fbd318006e74634bc19a25af7a621cfc452e201ff78fd82b"
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
