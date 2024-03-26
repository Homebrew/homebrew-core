class Scalr < Formula
  desc "\"scalr\" is a command-line tool that communicates directly with the Scalr API"
  homepage "https://github.com/Scalr/scalr-cli"
  url "https://github.com/Scalr/scalr-cli/archive/refs/tags/v0.15.5.tar.gz"
  sha256 "23a554dc856fe1718e92cfa4108b856ddcb9facd5197259026e45c2037dc978f"
  license "Apache-2.0"

  depends_on "gnu-sed" => :build
  depends_on "go" => :build

  def install
    ENV["VERSION"] = version

    system "gsed -i \"s/0.0.0/${VERSION}/\" main.go" # This is how the official build sets the version: https://github.com/Scalr/scalr-cli/blob/3bac4218a625d7512b0947777a34c190dca0e626/.github/workflows/release.yml#L6
    system "go", "build", *std_go_args(ldflags: "-s -w -extldflags \"-static\"")
  end

  test do
    assert_equal "#{version}\n", shell_output("#{bin}/scalr -version")
  end
end
