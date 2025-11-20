class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.02.01.tar.gz"
  sha256 "2cc930169e78fe6504491c4125a17fcedfc4b0c5446a738f339b428b4823e2c2"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "d4e7741276e4146dcac3736a054451b76a567309483b6c0930a7855709bac535"
    sha256 arm64_sequoia: "9cec4b12ff7fcbfffefd28ac78d1baee96b87296fa2f2b4273c74e20876e5712"
    sha256 arm64_sonoma:  "99b9ad1f0fb36a16385667088060c5c71a83280c14763881236fa6f3de1d352a"
    sha256 sonoma:        "fcae8dabc0b24941ef89b8950c57f834acc47793ab14a9ddef98403bdcc0a8e4"
    sha256 arm64_linux:   "b1425b7d542aedd8db403d61f7642389a874876e56acbc222f1897d5d3d7367c"
    sha256 x86_64_linux:  "c2c6f0efb5e736f319c27a2d91ba8ebcee4ab1076a6783f08e05530b80bd4bcf"
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
