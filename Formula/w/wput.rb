class Wput < Formula
  desc "Tiny, wget-like FTP client for uploading files"
  homepage "https://wput.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/wput/wput/0.6.2/wput-0.6.2.tgz"
  sha256 "229d8bb7d045ca1f54d68de23f1bc8016690dc0027a16586712594fbc7fad8c7"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "228f7a8a4bc5246862d4ccdd64c22f11ae8fc5400f1a5a923ca999ad308a5919"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c7b895351c316eeb37308ac163b54d36c997c2909a00b7ecf3837081af4a1e4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "396180470ace5f8d7640f2097bded1f66af50bac01ba8470ea3023968bc39d6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f892df6bfff0d575edbbd428c2decb1005b7c8faac2a709976c6489fc7e6719"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0899932c8dc9e51846277c672a4e4a9dcc36c1d999cb460d2e337a927b702a76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3456f7990bc7b2caa2d5a3afbff6bb921ee346030a07f4be9a31166c28609bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "3300e6e7bbc43adc8f1525c8badcf307029b63127163912115555b7b5e99525f"
    sha256 cellar: :any_skip_relocation, ventura:        "40cca9132e6826d07f8237bbb27419b55012b3e45aee55c39e1e0945f8201afc"
    sha256 cellar: :any_skip_relocation, monterey:       "39c0ebbfc7502644b9df207fae398036caef7cfcee63d340776d036893964610"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a5d49be96808777f249d96b6f86e2e0e0e301be0e929ba1eaea99cf79cacf42"
    sha256 cellar: :any_skip_relocation, catalina:       "77703d5dfb1bde183ccc207ee5e3f14b1a677acc697806a2b16f00c56cc0595e"
    sha256                               arm64_linux:    "ec9a4b8e069c941c18e07b232a30c5e5daf926003d9ff6120b0ac1e21d1f0e5b"
    sha256                               x86_64_linux:   "0fb27e180b9a6f8ef2b3508530874b467449fdac55a347c63f2e86ca360db073"
  end

  on_arm do
    # Added automake as a build dependency to update config files for ARM support.
    depends_on "automake" => :build
  end

  # The patch is to skip inclusion of malloc.h only on OSX. Upstream:
  # https://sourceforge.net/p/wput/patches/22/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/wput/0.6.2.patch"
    sha256 "a3c47a12344b6f67a5120dd4f838172e2af04f4d97765cc35d22570bcf6ab727"
  end

  def install
    if Hardware::CPU.arm?
      # Workaround for ancient config files not recognizing aarch64 macos.
      %w[config.guess config.sub].each do |fn|
        cp Formula["automake"].share/"automake-#{Formula["automake"].version.major_minor}"/fn, fn
      end
    end
    ENV.append_to_cflags "-fcommon" if OS.linux?
    system "./configure", *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system bin/"wput", "--version"
  end
end
