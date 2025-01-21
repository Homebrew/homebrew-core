class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.02.02.tar.gz"
  sha256 "d5ac5f4e159f9d4a03f7980f3e231db86bcb28c2938ea0c8c3ea80ec9ba21c20"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "758920aa4c3410e6479ee0e9efeae983830538bd52ab0d95068beccc11cc131a"
    sha256 arm64_sonoma:  "d85239631470005997db551d2d381a78a558927e290e8d3b00c873deca95f145"
    sha256 arm64_ventura: "839d3419e977bd73e70da7c9f0f89d634d8bd493ea35f936f51ca31e833cc44d"
    sha256 sonoma:        "a5ad6b52934c3cdd8223df490fe5b2ae10a781865a54ffd71ba45f31bac98943"
    sha256 ventura:       "ae120658c6c767c07712270efd28248cbe5077c90280698483c26e299c5c0437"
    sha256 x86_64_linux:  "4e51129044e7cb110bd215de165544a2a2abb182edd7b0628cafda0ff164e18f"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"reminders").write "ONCE 2015-01-01 Homebrew Test"
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders 2015-01-01")
  end
end
