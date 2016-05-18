require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.6.16.tar.gz"
  sha256 "c84bae32a170d993982de9c537eac74f70601e7a667dc2ea9803b86e04b1221d"
  head "https://github.com/hashicorp/terraform.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "634e81edcc7b8a23a45701a89a7674d0e42029052a0a6773ded8fec0fc85e34d" => :el_capitan
    sha256 "19f698b20da37ec5256f9446f03f78000fc4d1719540580abb4c9b6e3b535227" => :yosemite
    sha256 "c72e135740cbf6cbddfaf27bda8b3c9935e787ca2e6f11d03566477e50899b1b" => :mavericks
  end

  depends_on "go" => :build

  terraform_deps = %w[
    github.com/mitchellh/gox 770c39f64e66797aa46b70ea953ff57d41658e40
    github.com/mitchellh/iochan 87b45ffd0e9581375c491fef3d32130bb15c5bd7
  ]

  terraform_deps.each_slice(2) do |x, y|
    go_resource x do
      url "https://#{x}.git", :revision => y
    end
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git", :revision => "977844c7af2aa555048a19d28e9fe6c392e7b8e9"
  end

  # This patch works around a known test failure, which will be fixed in terraform version 0.6.17.
  # https://github.com/hashicorp/terraform/issues/6709
  # https://github.com/hashicorp/terraform/commit/6a20e8
  patch :DATA

  def install
    ENV["GOPATH"] = buildpath
    # For the gox buildtool used by terraform, which doesn't need to
    # get installed permanently
    ENV.append_path "PATH", buildpath

    terrapath = buildpath/"src/github.com/hashicorp/terraform"
    terrapath.install Dir["*"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/mitchellh/gox" do
      system "go", "build"
      buildpath.install "gox"
    end

    cd "src/golang.org/x/tools/cmd/stringer" do
      system "go", "build"
      buildpath.install "stringer"
    end

    cd terrapath do
      # v0.6.12 - source contains tests which fail if these environment variables are set locally.
      ENV.delete "AWS_ACCESS_KEY"
      ENV.delete "AWS_SECRET_KEY"

      terraform_files = `go list ./...`.lines.map { |f| f.strip unless f.include? "/vendor/" }.compact
      system "go", "test", *terraform_files

      mkdir "bin"
      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      system "gox",
        "-arch", arch,
        "-os", "darwin",
        "-output", "bin/terraform-{{.Dir}}", *terraform_files
      bin.install "bin/terraform-terraform" => "terraform"
      bin.install Dir["bin/*"]
      zsh_completion.install "contrib/zsh-completion/_terraform"
    end
  end

  test do
    minimal = testpath/"minimal.tf"
    minimal.write <<-EOS.undent
      variable "aws_region" {
          default = "us-west-2"
      }

      variable "aws_amis" {
          default = {
              eu-west-1 = "ami-b1cf19c6"
              us-east-1 = "ami-de7ab6b6"
              us-west-1 = "ami-3f75767a"
              us-west-2 = "ami-21f78e11"
          }
      }

      # Specify the provider and access details
      provider "aws" {
          access_key = "this_is_a_fake_access"
          secret_key = "this_is_a_fake_secret"
          region = "${var.aws_region}"
      }

      resource "aws_instance" "web" {
        instance_type = "m1.small"
        ami = "${lookup(var.aws_amis, var.aws_region)}"
        count = 4
      }
    EOS
    system "#{bin}/terraform", "graph", testpath
  end
end

__END__
diff --git a/state/remote/atlas_test.go b/state/remote/atlas_test.go
index 847fb39..1a6c710 100644
--- a/state/remote/atlas_test.go
+++ b/state/remote/atlas_test.go
@@ -159,8 +159,8 @@ func TestAtlasClient_UnresolvableConflict(t *testing.T) {
 	select {
 	case <-doneCh:
 		// OK
-	case <-time.After(50 * time.Millisecond):
-		t.Fatalf("Timed out after 50ms, probably because retrying infinitely.")
+	case <-time.After(500 * time.Millisecond):
+		t.Fatalf("Timed out after 500ms, probably because retrying infinitely.")
 	}
 }
 
