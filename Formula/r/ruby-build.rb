class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://rbenv.org/man/ruby-build.1"
  url "https://github.com/rbenv/ruby-build/archive/refs/tags/v20261119.tar.gz"
  sha256 "0d55d368b3157156d011b5f419c8a3758036210a602beeff8d0dfec329db0dc5"
  license "MIT"
  compatibility_version 1
  head "https://github.com/rbenv/ruby-build.git", branch: "master"

  bottle do
    manifest_sha256 "851d7a48a5582441268a78a5cf53732f245829640b6d1766c04fbd6f8c4bc784"
    sha256 cellar: :any_skip_relocation, all: "cb985682641ba8a1fe1c68eb406b57aeb11fa37c03f749d32a47cd139cb04109"
  end

  depends_on "autoconf"
  depends_on "libyaml"
  depends_on "openssl@4"
  depends_on "pkgconf"
  depends_on "readline"

  deny_network_access!

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruby-build --version")

    assert_match "2.0.0", shell_output("#{bin}/ruby-build --definitions")
  end
end
