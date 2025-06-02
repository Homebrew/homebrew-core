class Topiary < Formula
  desc "Uniform formatter for simple languages, as part of the Tree-sitter ecosystem"
  homepage "https://topiary.tweag.io/"
  url "https://github.com/tweag/topiary/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "e2bbac9cb46a3743cc41ca55245026580308722242c9df84bc0ef3cbb989aa81"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ff6e9f5f0ba1896fed926e9f708b6963c1e5340067a32300fad8837d63a9861"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fab50ec587b88dc7aae8a6749dc27e5b71101059a6055dde8b6e142d8e6a751"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f891576edc8f8c888ddec6065c05c1bf1c7d85638ea7040b5a4616ecfdd6c5c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e332169f12e5ce6bca20a04bcef4f43da972455a1b8957e6f860916667b1939"
    sha256 cellar: :any_skip_relocation, ventura:       "6ff37a98ed98b3572c53dfa85ce8ef34c2a2d92a9a31be38d032b07ee1d48f7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2222cab84529fa6b8043d52d4c0e6f6d06473a988d0b0d4de7a29c7f52083885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5aa363b87cdb615b19b242655d855caed29388a8c93a85db2b5946a2a979752"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "topiary-cli")

    generate_completions_from_executable(bin/"topiary", "completion")
    share.install "topiary-queries/queries"
  end

  test do
    ENV["TOPIARY_LANGUAGE_DIR"] = share/"queries"

    (testpath/"test.rs").write <<~RUST
      fn main() {
        println!("Hello, world!");
      }
    RUST

    system bin/"topiary", "format", testpath/"test.rs"

    assert_match <<~RUST, File.read("#{testpath}/test.rs")
      fn main() {
          println!("Hello, world!");
      }
    RUST

    assert_match version.to_s, shell_output("#{bin}/topiary --version")
  end
end
