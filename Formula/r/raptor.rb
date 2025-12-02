class Raptor < Formula
  desc "RDF parser toolkit"
  homepage "https://librdf.org/raptor/"
  url "https://download.librdf.org/source/raptor2-2.0.16.tar.gz"
  sha256 "089db78d7ac982354bdbf39d973baf09581e6904ac4c92a98c5caadb3de44680"
  license any_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later", "Apache-2.0"]
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?raptor2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1bfb13b805a48dff3dabd1424ffdccda68a6862eb2b245f544e8cf9b1a02c0d8"
    sha256 cellar: :any,                 arm64_sequoia: "d912659b927b80b53f507ae55e23bd3761c500f1e93d076b150f07b4b72ab9c9"
    sha256 cellar: :any,                 arm64_sonoma:  "7ac8f488fd862d5430615e09904b0557067827f5295609a7c1484362bac6f0f8"
    sha256 cellar: :any,                 sonoma:        "3497318f771ce19a3c8184d9497ddee0e20fd9255507a7004d4d48c47c48c096"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a740a47101fb3c218cb991c1e0a17171d581fe40065550ba25f50c325466e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef7db540be1c6410ffe3fe285641fa07a3eb71f81908de7f36f801c16484f333"
  end

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  # Fix compilation with libxml2 2.11.0 or later. Patch is already applied upstream, remove on next release.
  # https://github.com/dajobe/raptor/pull/58
  patch do
    url "https://github.com/dajobe/raptor/commit/ac914399b9013c54572833d4818e6ce008136dc9.patch?full_index=1"
    sha256 "d527fb9ad94f22acafcec9f3b626fb876b7fb1b722e6999cf46a158172bb0992"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"rapper", "--output", "ntriples", "https://planetrdf.com/guide/rss.rdf"
  end
end
