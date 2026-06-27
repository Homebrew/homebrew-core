class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.02.07.tar.gz"
  sha256 "cc13a1dfc4326177592e12439a9ac02e8f611ca862539b98947944e98aa297dc"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "cc99df8bb39473f6cf757ae3f2f39981517c86a5a4b521f7130c05cfcdbf72b9"
    sha256 arm64_sequoia: "9c7cf361bc7ff3faa1490c9ca117cb2b89ac2617b813b5f6ca2e4a94a5324f4d"
    sha256 arm64_sonoma:  "c06d81cfd3201b07a9fe313c053f6aeff8cc88682393fd188f61fa7de2935283"
    sha256 sonoma:        "d69d5224687ace645e7503002cdeb1234ab70ff5c9e279e009b5321cd029fd96"
    sha256 arm64_linux:   "971b3bc6baa730a55be48b0a697127fb698df0e251c7e8ca17afe4a9b2157393"
    sha256 x86_64_linux:  "67873d3d9da729ff8ab9b7fa15cea05bf5796033789604d3fbd4adb59fa34594"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  def install
    # Fix to error: unsupported option '-ffat-lto-objects' for target 'arm64-apple-darwin24.4.0'
    inreplace "configure", "-ffat-lto-objects", "" if DevelopmentTools.clang_build_version >= 1700

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
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
