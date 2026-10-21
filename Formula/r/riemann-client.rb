class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://git.madhouse-project.org/algernon/riemann-c-client"
  # Using git checkout to avoid Forgejo upgrades impacting git archive tarballs.
  url "https://git.madhouse-project.org/algernon/riemann-c-client.git",
      tag:      "riemann-c-client-2.2.2",
      revision: "36cf5cde0648c8ae953f7636bedbf6fab02d58ef"
  license "EUPL-1.2"
  revision 1
  head "https://git.madhouse-project.org/algernon/riemann-c-client.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2e70c2d1cf344a868f00c4becb77522d02cefbd29f26065bb13d0262728e08b1"
    sha256 cellar: :any, arm64_tahoe:       "08a1843e189bd5d712a548acb00fbd65ed8a3b5860cfc97450bc6f83468072a0"
    sha256 cellar: :any, arm64_sequoia:     "a86f02ef998ec3675abcffb7d34b6d5e9a9322d0b2c2d440b4dbac689233a5b2"
    sha256 cellar: :any, arm64_linux:       "0c2b3e6d998e21a01c99e69b2b2ff5f67bc272ee85cd505a02973c7d2f51fa7b"
    sha256 cellar: :any, x86_64_linux:      "a66c25c2c783bf2a638d99da67945f98811d26e55540401a0ec775c28621a6eb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "json-c"
  depends_on "openssl@4"
  depends_on "protobuf-c"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--with-tls=openssl", *std_configure_args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"riemann-client", "send", "-h"
  end
end
