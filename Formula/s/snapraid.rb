class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://www.snapraid.it/"
  url "https://github.com/amadvance/snapraid/releases/download/v15.0/snapraid-15.0.tar.gz"
  sha256 "ceba44e15566386d923d6895ecab81f7437848b03a4cf9585c02d3636197ce19"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a2f425165f4bca9571b0362fb10fe2e3fc4af8fd01934e93fbb2c66a0f152861"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c076eb8036d68d5a76afa2155b869ec3badb64f81bfa00cb25ece2013215a0f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd8e5f73c7d268cc222878a1233bc9dd2a82b1df83e7b63a261c456b4ac99a65"
    sha256 cellar: :any,                 arm64_linux:       "e4e71769bf98f690ea5592656c71ae18d3a7cd240b0aae9aaeda901265ce7afe"
    sha256 cellar: :any,                 x86_64_linux:      "8387f7883b80460fd403de2cdf23f48b7d9ced552e453009c32d1fd13a4b9374"
  end

  head do
    url "https://github.com/amadvance/snapraid.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
