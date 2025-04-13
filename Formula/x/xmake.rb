class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.9.9/xmake-v2.9.9.tar.gz"
  sha256 "e92505b83bc9776286eae719d58bcea7ff2577afe12cb5ccb279c81e7dbc702d"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "229df9b130670e6cf6aac4eb40c7da7e7326a51590825ab7d3a88906f9d28641"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46be66d19719757ac9be1671a03db504e7b9935839aa71eefa38fd920e206a1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a604af6cb9d7fcd407984f926d784bdc37e4c7ee54353f309922ae81225f64cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1502c976b1f86c1ed83e4252d3b1968fa737f1fdded96b39bb99885cd933a460"
    sha256 cellar: :any_skip_relocation, ventura:       "434637aa25d9aab519ddb1921283b80c1e3f4e157d5daa9a3e2ad53d980e2049"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2736e9040b9d0e6a81c0254eb128315593146c8b5bdea8b0e55e571800a48ad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fb887965f9e42b267002ef34b6553cdadc105285a309be531e29f11feddd76d"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./configure"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    ENV.delete "CPATH"
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
