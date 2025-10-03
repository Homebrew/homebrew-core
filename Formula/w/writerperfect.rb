class Writerperfect < Formula
  desc "Library for importing WordPerfect documents"
  homepage "https://sourceforge.net/p/libwpd/wiki/writerperfect/"
  url "https://downloads.sourceforge.net/project/libwpd/writerperfect/writerperfect-0.9.6/writerperfect-0.9.6.tar.xz"
  sha256 "1fe162145013a9786b201cb69724b2d55ff2bf2354c3cd188fd4466e7fc324e6"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    regex(%r{url=.*?/writerperfect[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "019f7df6196f57ac72fef8f42879191724bbd71243f5d55df485b5aa7b583eec"
    sha256 cellar: :any,                 arm64_sequoia:  "1bcef69c7269aac0ca31db30c82ca222f1ae0a9a9d4e19cb55d3bd7f28974327"
    sha256 cellar: :any,                 arm64_sonoma:   "ed3b788e7dfc919303efa063cf9a46553e132339c36016af524e4b5e021f6ec8"
    sha256 cellar: :any,                 arm64_ventura:  "27bbb6aa97e00bc78675eebde04a4b08754fca44b466df2f1c8dda4180293c6c"
    sha256 cellar: :any,                 arm64_monterey: "e5cbdebbad8e36cc2cd59a140c2eb4a8a5fd914b4ed9360fa3f1a4042cd74efe"
    sha256 cellar: :any,                 arm64_big_sur:  "00f00e38b26c51048a374d8becec3fbc1c1b1c05105710761575ae4906194920"
    sha256 cellar: :any,                 sonoma:         "7748782d562017ce5a6acaa24d6f9609aec50c65899f5c0bd983e9b997851c48"
    sha256 cellar: :any,                 ventura:        "1411634e211f31dd5ea7d9b6dee254337eb61a68a540104310d7f5ccc1f01ee3"
    sha256 cellar: :any,                 monterey:       "bcebaf60ba257cf542554dae36548c5fb0d7b8f1ef7a7c85b55637c1e8bc28aa"
    sha256 cellar: :any,                 big_sur:        "434788af114e54153fe89b17ff3c0ddfd879ffd0e59ac822821ede791a33d145"
    sha256 cellar: :any,                 catalina:       "d9a391e73e78b29ced39f355c8d52fbba4198af66c578b9d41257422a969cd17"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1880e89aea024d9aeb907f7aca699b2e6f4f6913ad2aa7c5cd8757e06cb80ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ba99fa8423726871a3437205306e9cec03cc3715ed8630f1e29acd7ae74be14"
  end

  depends_on "pkgconf" => :build
  depends_on "libodfgen"
  depends_on "librevenge"
  depends_on "libwpd"
  depends_on "libwpg"
  depends_on "libwps"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end
end
