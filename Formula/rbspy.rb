class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.3.5.tar.gz"
  sha256 "4002471d4d806eee24e1636dfe5c764433beb3629ce439c5167cb7ccf37e3c72"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd790f4162891858c6dd0c701cbe5ac57e6a675ed6ebac5f7d15b34d34d14538" => :mojave
    sha256 "c725b8ecbbf3f862b90c74e1d1fa2ba15b34efd39a63bdd55c063f0e883a983f" => :high_sierra
    sha256 "057cfc99fa9b11f60a22abd6dbc54c4764d9af78e291971174e0f42cf9c76eb0" => :sierra
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
