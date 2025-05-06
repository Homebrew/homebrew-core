class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://github.com/LucasPickering/slumber/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "9d3a7ef79c04175ce6b69cfe5b4b5aac761aee41e0d9fd5cbbad5a038f059092"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4acf5df08883a77829743182e5993f3a20a1b5505158f7f15424a8697b335494"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebd1dde7678cd9b91a58eb84a3f5dd64d152599f98aa480f9df08966472336ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "489a5a74c72d3d8c0f35cbc343a5820a7c1962c4cdd4235b9c3b782ffe2cf92c"
    sha256 cellar: :any_skip_relocation, sonoma:        "78fd4463d86642b1a382048983b272a2d4f699bb881631b70e27d294d75db0e6"
    sha256 cellar: :any_skip_relocation, ventura:       "90cbc3f21ec6f05b7c03a2af4ad7f965abc5ac4fea5eb71b4d73204d069322ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50072a67d65a4c07716263c000de4d066ae0db8b3b117840ce5c9b7bcf364e38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00d4dedeca58b7d0d97eb518513ac5fc98d73dd916ed5f14e696eef01c1ac6e2"
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
