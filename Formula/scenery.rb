class Scenery < Formula
  desc "Terraform plan output prettifier"
  homepage "https://github.com/dmlittle/scenery"
  url "https://github.com/dmlittle/scenery/archive/v0.1.1.tar.gz"
  sha256 "ae1c662ebe70c63baa3ddd8c0875fd2d132e3d0511619257c60369fd2ea18893"

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"
    ENV["CGO_ENABLED"] = "0"

    path = buildpath/"src/github.com/dmlittle/scenery"
    path.install Dir["{*,.git}"]

    cd path do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"scenery", "-ldflags", "-w -s -X main.Version=v#{version}"
      prefix.install_metafiles
    end
  end

  test do
    input = <<~EOS
      An execution plan has been generated and is shown below.
      Resource actions are indicated with the following symbols:
        + create

      Terraform will perform the following actions:

      + module.module_name
        id: <computed>

      Plan: 3 to add, 0 to change, 0 to destroy.

      ------------------------------------------------------------------------
    EOS

    expected_output = <<~EOS
      + module.module_name
          id: <computed>

      Plan: 3 to add, 0 to change, 0 to destroy.
    EOS

    output = shell_output("echo '#{input}' | #{bin}/scenery")
    assert_match expected_output, output
  end
end
