class Tsung < Formula
  desc "Load testing for HTTP, PostgreSQL, Jabber, and others"
  # `http://tsung.erlang-projects.org/` is no longer accessible,
  # upstream bug report, https://github.com/processone/tsung/issues/417
  homepage "https://github.com/processone/tsung"
  url "https://github.com/processone/tsung/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "6c55df48b82f185dfd60ae7271e09bbc25c6c8bc568bb8bfc0cdb056d77c3899"
  license "GPL-2.0-or-later"
  head "https://github.com/processone/tsung.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49d55c65d11487c31015102992d20c0853656fc09b85e6f35570573417a949ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d847edc850acbfe70004c707b2ec18962c7b83877efb2bd576f23fc31119d82f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e611fcda350d09739af49168a0514ad347454c0d4d1722f18fe254f98334ee9"
    sha256 cellar: :any_skip_relocation, ventura:       "92304f38be35fef5b26c9469042c657220ee200d1c3fcd88ecb3b98b1a1063e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e15a598cd9b077c6cd445b23a56d8d799f7ea330c92cea542d244bdc3d82aa36"
  end

  depends_on "erlang"
  depends_on "gnuplot"

  def install
    system "./configure", *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system bin/"tsung", "status"
  end
end
