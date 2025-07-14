class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://github.com/LucasPickering/slumber/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "dcd3f5d74abc6fa764164ead0cd52368d92122f395353ed43091ad1f02498d95"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dcece418e59817739e3a2fd7c6d2882bf55b9a2c5432d84aac8eaad8860b45b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e593f93abad659727f59a298ae44c1947742dc842d7e17ce231314cf3eb56cf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3fc180f5273c549b2a23833c31768b3ee1feda416e2ee2f8ada2e94a88f8433"
    sha256 cellar: :any_skip_relocation, sonoma:        "d659db420c63df323695811a89d5e884f873660f1af2171c32cb4d29e26fe888"
    sha256 cellar: :any_skip_relocation, ventura:       "ca8b1a461c051925d684e387ab92e837e93e7977c1df804bc4c6c559c37b3ed7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "700ec0b83b6bfa7a7586cf4d1c60c58cc453a02d9624b7200c73e6fb3fcb3355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f8c857687cafc558d7daaf3da169f1938a5b5697d880801fcf6b749840c58f4"
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
