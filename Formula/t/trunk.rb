class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunkrs.dev/"
  url "https://github.com/trunk-rs/trunk/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "b8ed1ba9a048d71e0056e2b93c06858d68df25796d0d5515754b1c8610f368aa"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c75ddb953eb4282811c5af0bd6c54a3543c5437d0c95bc03e6f7bb82ca20f87d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b66b3c8009f028b4d2038a886cc832e583a5abbe23b6649ac7264dba4f085d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eec2f6fc12cd07cdaa603227bd25d42715c4f6b83be0a8a43fffc370e7123d55"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b18685f5417c4f72ea1cd62eaa89850b45f290575bc3235246023a50359657f"
    sha256 cellar: :any_skip_relocation, ventura:        "df6cae3a8bf97db970e31c9376652cf6f36f6be7dbcd093d44161d8c1e1036ba"
    sha256 cellar: :any_skip_relocation, monterey:       "cd19645539c5e35776ea5048e7c3b0d5ea59fbfe0091352b143a3ca976ffd69b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e03e5a1dc449c555cfce720dd6c5097d9b639f8347df2cc5dd60e56893710ec"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
