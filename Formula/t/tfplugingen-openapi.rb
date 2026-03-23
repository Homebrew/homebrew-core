class TfplugingenOpenapi < Formula
  desc "OpenAPI to Terraform Provider Code Generation Specification"
  homepage "https://github.com/hashicorp/terraform-plugin-codegen-openapi"
  url "https://github.com/hashicorp/terraform-plugin-codegen-openapi/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "30bbf07996185312f8d7ad42163b6f1bcb756adfdd8ec981d63c72c4b7b1e721"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-plugin-codegen-openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0aeb3eacbc8acbd4b5b6a3def118e3b020a5b46615cb1404b35ba8172aba72e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0aeb3eacbc8acbd4b5b6a3def118e3b020a5b46615cb1404b35ba8172aba72e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0aeb3eacbc8acbd4b5b6a3def118e3b020a5b46615cb1404b35ba8172aba72e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd1f2d1c1db38774680f5db82b743824fbcedfc44be28f67bcd33ce49f293190"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb727f1c401fbe225a9407b9aa7e326bf4dd15fe2e1b5c938a467b26fe9bf387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13808c557251e72adfa46d56d9194aef2a947568441e4bc422489891a6387852"
  end

  depends_on "go" => :build

  def install
    commit = build.head? ? Utils.git_short_head : tap.user
    ldflags = "-s -w -X main.commit=#{commit} -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tfplugingen-openapi"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfplugingen-openapi --version 2>&1")
    assert_match "OpenAPI specification file is required", shell_output("#{bin}/tfplugingen-openapi generate 2>&1", 1)
  end
end
