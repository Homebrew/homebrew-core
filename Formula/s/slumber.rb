class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://github.com/LucasPickering/slumber/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "5fee9f4e2618bb2744646c9265c77daefea2edbc66ef7cc498fc297dea0c370d"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25f1ab8e8c7ea2d65d7af8337138a0d9a82eabf54c2c9983695ce4fe28bb125d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc01344eabb9b67a74926cc8f71a4dd816a5d51c3b28c645e1e42051f03a2700"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e50f3fc774df4d7ebe99552e1fad67325b6263a9f7c3d2e8e3c9619668a3e667"
    sha256 cellar: :any_skip_relocation, sonoma:        "228e5c263f746437840f81da9f2cbdfd113d029f1232b58f396408830be26df2"
    sha256 cellar: :any_skip_relocation, ventura:       "99e6ce13ecaa9ece6d74b486dfa815bd21068b3609f3b85964c3442df3f69ce0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e98bf1c9ce12f7e82917e33d9ba1b7861e4caf0ec21d838b6251b01320a68db3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b5c94440ccd5657f36feed9aa4ebd8dca751ee21afb8ca9b07a4892ea45012b"
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
