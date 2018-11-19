class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.3.3.tar.gz"
  sha256 "15b8c43f3071e5ae5dad4920cbd6a743b8d6c64e0bc90e1ebe86db2fd79fb3e5"

  bottle do
    sha256 "8f72dc4de0f3aa3e5a8e13ebf2780e27197bebc1739f71815fc3152bcb637ad2" => :mojave
    sha256 "ee4e97a5d5c4f504b7d515413a3d1e6cb25d9f3aa03402d8229e05ae472fd0c9" => :high_sierra
    sha256 "14e3be1280ccdea0439be4c3ec312d343b930702de1ed7619d4c9dc39ae1baa6" => :sierra
    sha256 "bd5d462b459c05063bfc858568af6d0f1e082e06d199d9625998208ed61964b8" => :el_capitan
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
