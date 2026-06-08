class Zsv < Formula
  desc "Tabular data swiss-army knife CLI"
  homepage "https://github.com/liquidaty/zsv"
  url "https://github.com/liquidaty/zsv/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "0db9632ec173c1fe61a50c6269dba68e6b0a21fdb6608219f18a2cd866a9a444"
  license "MIT"
  head "https://github.com/liquidaty/zsv.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c90f6560691b4a1ca27521ddf17e87aa997164b6e6f1b7a30addd8394aa1e803"
    sha256 cellar: :any,                 arm64_sequoia: "a77a59331251d371990949308a013eb7e85f06c31f0996199c480800c312de7c"
    sha256 cellar: :any,                 arm64_sonoma:  "fd7408fd79d3df8d0384802d338c48e13b19d4ccde72a27987a4369afcf49c13"
    sha256 cellar: :any,                 sonoma:        "1e1ec0ed873ce304d4917f5a85fc3f6d14c30251863e071df4c3448fcb7732c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62c1e84e7fe7b03618fc2b3f319c8bfa996977122e7cb3c23541262ae1691b26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef8444f81b92d9683b17f4db3b845522b245aee24a44538b58ad86a2fac72306"
  end

  depends_on "jq"
  depends_on "pcre2"

  uses_from_macos "ncurses"

  def install
    rm(Dir["app/external/{jq,pcre}*"])

    args = %W[
      --jq-prefix=#{Formula["jq"].opt_prefix}
      --pcre2-8-prefix=#{Formula["pcre2"].opt_prefix}
      --ncurses-dynamic
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install", "VERSION=#{version}", "PCRE2_STATIC="
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zsv version")

    input = <<~CSV
      a,b,c
      1,2,3
    CSV
    assert_equal "1", pipe_output("#{bin}/zsv count", input).strip
  end
end
