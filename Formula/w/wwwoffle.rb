class Wwwoffle < Formula
  desc "Better browsing for computers with intermittent connections"
  homepage "https://www.gedanken.org.uk/software/wwwoffle/"
  url "https://www.gedanken.org.uk/software/wwwoffle/download/wwwoffle-2.9j.tgz"
  sha256 "b16dd2549dd47834805343025638c06a0d67f8ea7022101c0ce2b6847ba011c6"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.gedanken.org.uk/software/wwwoffle/download/"
    regex(/href=.*?wwwoffle[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4271aaf534eb22540919ee96421505f563d10d36ce5739e601c4dc081ce4aad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5a78e7a96141163fc8dd6c96eabdc4f9b6e0dec096fa2f1a1c10ea265821217"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87d5a20edc5f38d7b798349ad1f4e91757269f302a7418c4d1e9ed4107d345ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8803975add1a42df0e2f76a9383f0adf59b989b65f8160bb583d9cd0005a84e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17aebaafaf5c692ab2df961a1a62296ffe446b6931be7594c4ab9a2eedfabeac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8da30132b4acc20d48d72205eff5fefb3cc1f3ecaaf5aa5a1efa4e1aadd8ea5"
  end

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm64?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"wwwoffle", "--version"
  end
end
