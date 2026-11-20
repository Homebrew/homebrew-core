class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.03.07.tar.gz"
  sha256 "38b2afaf4cc2ef5642c8ea85c61c3658d575a381be58baf4a5a05f419a9637a2"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_golden_gate: "26e8948e2b76674d2dffe49ec1bdc4d9c1882e0a7babd0f8824932c6dfce3258"
    sha256 arm64_tahoe:       "ebb2d3b3a6ce541f49190c9f5422beadb40842d985d280320459d7a61c623230"
    sha256 arm64_sequoia:     "ae4487c0fecab29d95613323ea30d52976298b31878e799fa96f0f63e7785f1e"
    sha256 arm64_linux:       "9c4004235f02711015692419a4abef4c693f0bcb2f4a3afef6fd2d592a19cbc0"
    sha256 x86_64_linux:      "f1da0085493a30dde230a58bb8e34eed5303826ba8a9df142cc1614d8aea4b71"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  deny_network_access!

  def install
    # Exclude unrecognized options
    args = std_configure_args.reject { |s| s["--disable-debug"] || s["--disable-dependency-tracking"] }

    system "./configure", *args
    system "make", "-C", "src", "install"
    system "make", "-C", "rem2html", "install"
  end

  test do
    (testpath/"reminders.rem").write <<~REM
      SET $OnceFile "./once.timestamp"
      REM ONCE 2015-01-01 MSG Homebrew Test
    REM
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders.rem 2015-01-01")
  end
end
