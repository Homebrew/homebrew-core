class Rmcast < Formula
  desc "IP Multicast library"
  homepage "https://web.archive.org/web/20250722003825/https://www.land.ufrj.br/tools/rmcast/rmcast.html"
  url "https://web.archive.org/web/20250621130503/https://www.land.ufrj.br/tools/rmcast/download/rmcast-2.0.0.tar.gz"
  sha256 "79ccbdbe4a299fd122521574eaf9b3e2d524dd5e074d9bc3eb521f1d934a59b1"
  license "QPL-1.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "de8e1fc85f602d20604c3e0a44e08c3dfc3e424f6faee2e65a0fed714646da3e"
    sha256 cellar: :any,                 arm64_sequoia:  "2550872c1731058ae467f82b6258659ace4cc86e091fa54f827daa61cd5677fc"
    sha256 cellar: :any,                 arm64_sonoma:   "d82904f97cda3eb5874bfca8ac452568a04efeadd88524fc2b1e03cb594ecca9"
    sha256 cellar: :any,                 arm64_ventura:  "07939c86d1018aeb45c483ea2e96514f24cc92fcca30f5ffe3ebdaa8f1a53b9d"
    sha256 cellar: :any,                 arm64_monterey: "bb3d3a129e3ac532f960335c23adb657e333751efee7243577c772f92abf31a6"
    sha256 cellar: :any,                 arm64_big_sur:  "7edab23a8770a245b0f06197b2d46c4777b8fdac0f39842ce619c56d74f1eef4"
    sha256 cellar: :any,                 sonoma:         "ba0051628bcd72a98bd0c0a4f9b055d106f5b8eba226b9b0c279013cfae729c6"
    sha256 cellar: :any,                 ventura:        "cecc9ec050585780015df098cbea1522dacdca625a2e9ae621b47bb975e5f559"
    sha256 cellar: :any,                 monterey:       "5f88f10530ed8ad07b13c512fba7310bee880f8bd138eac08d7fd37bb3be35e4"
    sha256 cellar: :any,                 big_sur:        "b2cc007eec98b5e422a7948e9e680f3a0d7c622eb4703f9b2bae6c867635107f"
    sha256 cellar: :any,                 catalina:       "e2054828627f6afdd376cfd276536c770b8dd77b082a44c5b63212e8dff84351"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d9f0ff68c1fcb1dabf6fad88d8987d71bea9d26634fdb94b2611149af01fa967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecbaa8a68d7cb766021fb1f1bff97c911a5e16720508cf71648c6e96a2b93c4f"
  end

  # 503 error for https://www.land.ufrj.br
  deprecate! date: "2025-09-15", because: :repo_removed

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # Run autoreconf to regenerate the configure script and update outdated macros.
    # This ensures that the build system is properly configured on both macOS
    # (avoiding issues like flat namespace conflicts) and Linux (where outdated
    # config scripts may fail to detect the correct build type).
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", *std_configure_args
    system "make", "install"
  end
end
