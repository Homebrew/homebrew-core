class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.3.8.tar.gz"
  sha256 "afde93875ef8cdd856e51002e2623bb896f4be6af494ffdcd2a69c2fe9e5cb5c"

  bottle do
    cellar :any_skip_relocation
    sha256 "99f2a1fdc5051876aee5166aeac783087010dd9ddf6399bfec4764a04d0dc27a" => :catalina
    sha256 "88c4b1f48597a0b0f7b0c5a679a9d4b898427c631d59b1aab2a93d9b69c2c86c" => :mojave
    sha256 "ac4f7a5cdc64e8c3fbf6a73e4dcf8312bdd74405b2bac1896f318b9afb5bfde7" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
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
