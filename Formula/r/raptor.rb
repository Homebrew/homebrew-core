class Raptor < Formula
  desc "RDF parser toolkit"
  homepage "https://librdf.org/raptor/"
  url "https://download.librdf.org/source/raptor2-2.0.16.tar.gz"
  sha256 "089db78d7ac982354bdbf39d973baf09581e6904ac4c92a98c5caadb3de44680"
  license any_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later", "Apache-2.0"]

  livecheck do
    url :homepage
    regex(/href=.*?raptor2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "26276eb455188d1b46f33144e3f71c7fb3bbcb0eeeecf990402b095fb90662d0"
    sha256 cellar: :any,                 arm64_sonoma:   "40dcde53bea22c1f9f190517ffb52d13fc1bd8cb2ee91cf7f9439718cf491ef4"
    sha256 cellar: :any,                 arm64_ventura:  "04bcb31c9be96a4763e3ea34843a0be60d5b4051fb89d65f0a8e63880d2256f7"
    sha256 cellar: :any,                 arm64_monterey: "1d0120b0dbca92597a7fe305a13ae1f3532fc5521ba7c61f26748d387240aab4"
    sha256 cellar: :any,                 arm64_big_sur:  "9cdd4d2a5c7cc9888072bbd8e6062ee1645b9b7e4ca371391fdbdd95a0a20f9d"
    sha256 cellar: :any,                 sonoma:         "7f1de091c7c497a3206f19766aae47a892668bfd4c551a3ccb10c936fcc193dd"
    sha256 cellar: :any,                 ventura:        "6e1542f6b1550034210dec5ce87896ef4be236e60ac6b4a21136b7029b7c2dc5"
    sha256 cellar: :any,                 monterey:       "d91142c6c8c5057b57a334ad8c8a856e620303cf4fefc4e9bc95a9715f9d338f"
    sha256 cellar: :any,                 big_sur:        "ba5e405a3c7b6f8f89e91474e1ebe98370a592ba3a2c8b506577c8e7197cd859"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8dbff84e7fe63b4dbb4e65820e2a053e02213acd4b71a026542321b07b5c9dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15e86d1b093c1984b4d6296466470f879edd31763d16b75130389046ca2cb4ec"
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
