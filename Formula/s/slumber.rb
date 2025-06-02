class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://github.com/LucasPickering/slumber/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "d0f15aca5112d0f633d927ee5661070a7b150881f04d2dcfd3a1adbcaef3c15b"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcf74904dcf1eb746f61708b4680fdf8f456de677af455b8b56f4a68c84f6e35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a30cc7102ed8873c821c7f77831d35aeb599f3b786e9c3fc23510d488a836069"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "141f3aeb47db6bfe1b5ee2cc0ce168ff5a75332e92deaf2b6e3393bcbbbe3614"
    sha256 cellar: :any_skip_relocation, sonoma:        "0db51ce58c284fc3c17bf21bab0d9f566a9dc925c61b4914e02b6c476e829442"
    sha256 cellar: :any_skip_relocation, ventura:       "58b034fbe74e4f8385be7c496520682df92c2eb359bc1ca247dd88cbfea14961"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2defcf04a12fcfd5f3d6f0d188b3cd04d0853f508fdeb8f5c08425dfa090aed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67649ef3a68e847e69c92caf480d24fd83a041b8fac9d50dd5a32452a2d77b8c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      # For basic usage info, see:
      # https://slumber.lucaspickering.me/book/getting_started.html
      # For all collection options, see:
      # https://slumber.lucaspickering.me/book/api/request_collection/index.html

      # Profiles are groups of data you can easily switch between. A common usage is
      # to define profiles for various environments of a REST service
      profiles:
        example:
          name: Example Profile
          data:
            host: https://httpbin.org
    YAML
  end
end
