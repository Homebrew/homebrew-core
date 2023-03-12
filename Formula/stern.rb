class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.24.0.tar.gz"
  sha256 "4c75684974935bf90ce939b579c1cd67844e586a189a2a84e1a86165092d7919"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "779bfcc0582b42cc58e40e0eb2df3c1051e4b362bcb2be09c4d4a33e9647c70c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a872d0f4339f4d49aec7c7466339c477fce387e9b65a9488d36444105fad494b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ba22acfc51250bb56dec297c93edf5259ff0ef7bd6fd9a0c3a2254818f8c85e"
    sha256 cellar: :any_skip_relocation, ventura:        "ee7e364fa474787dac605b33b162787e1766678e07f5c13c93340844aae5cac3"
    sha256 cellar: :any_skip_relocation, monterey:       "fd864cf5ad9a921d71edaa2e34478845f5a81514939e5ae02b9bd0962e01d556"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9c296769c4e62895fe661dc1e6f59b8226f282fc20de0f6602e22bb589d6033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ce12cade569bbd3bd5d21a513693dcb8cd3b393b29183c89c1c74c0f1b93e92"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/stern/stern/cmd.version=#{version}")

    # Install shell completion
    generate_completions_from_executable(bin/"stern", "--completion")
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
