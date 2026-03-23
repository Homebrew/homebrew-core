class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.20.01.tar.gz"
  sha256 "f974863d1861e7e7b5d19e381a17f22d653dcafa12096ac96d11b2e62a22ea77"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b9c17a9f5c90c21710ae9eb5daf3e33ad4b1dd3b36ea93dd390eddc5a4da6cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3211d447a12d9e4d533642929500ee92509e7ec5a569327e4e7690ff16959eb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3463363d8a8e425ed4a67003e2211475a1d3b8d194780bec2c78129321bbfdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "e62cda0f1edbb494d6de1403fbba8ca116d2fe70a1d7c769d9d54fb0e8430d9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "125bba36a20c4b9a045c71d41350843c2b7a8f390f6737b77e05aae0d2c5106f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fd64fb97d9b4982e138b59839e6afc63f6d5df501bc15c46708d25455e11b05"
  end

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "acl"
    depends_on "zlib-ng-compat"
  end

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
