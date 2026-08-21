class Snooze < Formula
  desc "Run a command at a particular time"
  homepage "https://github.com/leahneukirchen/snooze"
  url "https://github.com/leahneukirchen/snooze/archive/refs/tags/v0.6.tar.gz"
  sha256 "3a4a2f3f00d42e30647d9af79c8e417990ced6c3f0565474b1ca717938b1e2ab"
  license :public_domain

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cc6fe5e9304a054fb6cc06959c1e47141beadcd6d96de1c4be184d58d8e1006"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e18fcc8bc2fe5e5044ae0b487d0777e511a45c9d99e3db62a944e37f6d1d500"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfd7ab86834b8e8aa7e8a80ac2d7df2bb3cc728628871b13a5d0bde2499d501e"
    sha256 cellar: :any_skip_relocation, sonoma:        "898c5b17d653c2c7a042c658be961375b469250a3298738cc7f1f952908d2b10"
    sha256 cellar: :any,                 arm64_linux:   "21ea88b07615808acd25a08bf11b317ee097594d273d897e7aecc213c48b85e0"
    sha256 cellar: :any,                 x86_64_linux:  "3adae49c30ccf5d173b0efaddf7b990924d635d63cbd5083a5b2075186bb7eee"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "T00:00:00", shell_output("#{bin}/snooze -n")
  end
end
