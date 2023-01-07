class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.7.5/xmake-v2.7.5.tar.gz"
  sha256 "fc4a39a0c649e7469a2da2d66618ca3090050b1656ff43cf1fd46abc86232a3d"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c5d401ffb6484fc2bef8ff27507a95183edc0a613ff8f4ce5a1390eaf4933ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cc480b234eb2a5831ea98cf216d62ef529d3423afcb9b669279ee71cc9521b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "356a400a3cd194d59005cc6b9e573d6b0893eea36f07e059cc14ba58fc3f6d06"
    sha256 cellar: :any_skip_relocation, ventura:        "e446ce0af41f7c1201f731adc9d92da44151e1035075b508601f27ffa02894dc"
    sha256 cellar: :any_skip_relocation, monterey:       "e1df716e53e395f90b780598ebe5abeb2a921ec570680ec0d8b30970fde1dbb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f16c5abbc006bce0bd41c1953f498fdc30ce56ddabe92940cd26dddd636ec681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2da4513f8a093cf99c0b4120dba3c9c0539ff36a3b1780e6d1d313a09f0a96f2"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    ENV["XMAKE_ROOT"] = "y" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./configure"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    ENV["XMAKE_ROOT"] = "y" if OS.linux? && (ENV["HOMEBREW_GITHUB_ACTIONS"])
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
