class Xberg < Formula
  desc "Extract text, tables and metadata from documents and images"
  homepage "https://xberg.io"
  url "https://github.com/xberg-io/xberg/releases/download/v1.3.10/xberg-1.3.10.tar.gz"
  sha256 "d38be1f2984ef2861597c1398cf0d98ec661f506cd1fb21d801071e8a67b0b30"
  license "MIT"
  head "https://github.com/xberg-io/xberg.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "leptonica"
  depends_on "libheif"
  depends_on "onnxruntime"
  depends_on "tesseract"

  # The tree-sitter-language-pack crate builds its query registry from this bundle
  # and would otherwise download it at build time; keep it at the version in Cargo.lock.
  resource "tree-sitter-parser-sources" do
    url "https://github.com/xberg-io/tree-sitter-language-pack/releases/download/v1.22.1/parser-sources-1.22.1.tar.zst"
    sha256 "2e7fbeac46ca5cfb685c53cd8a92bb606a2724b124d28c5ac7d04ef9a913d756"

    livecheck do
      url "https://raw.githubusercontent.com/xberg-io/xberg/refs/tags/v#{LATEST_VERSION}/Cargo.lock"
      regex(/name = "tree-sitter-language-pack"\nversion = "v?(\d+(?:\.\d+)+)"/i)
    end
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Link the onnxruntime formula instead of downloading a prebuilt ONNX Runtime.
    ENV["ORT_LIB_LOCATION"] = formula_opt_lib("onnxruntime")
    ENV["ORT_PREFER_DYNAMIC_LINK"] = "1"

    # tesseract.pc lists libarchive and curl in `Libs`; only link what is used.
    ENV.append_to_rustflags "-C link-arg=-Wl,-dead_strip_dylibs" if OS.mac?

    # The build script verifies the bundle against a `.sha256` file next to it.
    parser_sources = resource("tree-sitter-parser-sources")
    bundle = buildpath/"parser-sources.tar.zst"
    cp parser_sources.cached_download, bundle
    (buildpath/"parser-sources.tar.zst.sha256").write "#{parser_sources.checksum.hexdigest}  #{bundle.basename}\n"
    ENV["TSLP_SOURCE_BUNDLE_URL"] = "file://#{bundle}"

    # `xberg/tesseract-dynamic` links the tesseract and leptonica formulae
    # instead of downloading and building vendored copies.
    features = %w[api mcp mcp-http heic xberg/tesseract-dynamic]
    system "cargo", "install", *std_cargo_args(path: "crates/xberg-cli", features:)

    generate_completions_from_executable(bin/"xberg", "completions")
  end

  test do
    # xberg 1.3.10 does not search the Linuxbrew prefix for tessdata.
    ENV["TESSDATA_PREFIX"] = Formula["tesseract"].opt_share/"tessdata" if OS.linux?

    (testpath/"test.html").write <<~HTML
      <html><body><h1>Quarterly report</h1><p>Revenue grew in every region.</p></body></html>
    HTML
    assert_match "Revenue grew in every region.", shell_output("#{bin}/xberg extract test.html")

    # A 1-bit PNG of the word "Homebrew", recognised by the linked tesseract.
    ocr_png = "iVBORw0KGgoAAAANSUhEUgAAAWgAAABQAQAAAAAcwNIMAAABo0lEQVRIx+3VQU7EIBQG4NeQiIuJ6M6F" \
              "Ga7hwgwexSO4dGGGTrqox5pmFl4DbsCSRcPvg87CGJrqTmPfijYfUB4PSvhJ0KpXver/phVG/fmVWvWf" \
              "1olsfJFOwylcEbxHawIGyKoeSccn0Uq0Ahsy/pBIBRy+znPWgVR8bEiCGlyS9oeRZLBz2j3IKNoLkWQL" \
              "ela+iVtR10SkHURUTnfczzaJW0yjbZOu6gFd1M4M0UQrIJ1x8NHSjD6BYbBZG8naOrho5nTHQxVtR6PQ" \
              "88gIY1VLXmVfNIZQdOc41axvX001Jz1PbLPGWZ9Y7xb1NLYvY28XNa9B4eRxJNqztlUtq/rh/ju6m/Td" \
              "oi4Vy/rEjc2c7qt6d48Z7c85yc99zgnr/fWSLntZMjivO66TrPPOc534vPN4298s6FJVyoOrCq1t6jpX" \
              "7KSDFanoAS1m9JFPQ9ajcqCo+TtMh+OcdntZdCLiCjYekQRrUdf5FGc9nWLrwaeYdVfTSUe+IYrmS2LD" \
              "9wkSaX6q6Bx8+0yNoIE+N46W+7zXddnp5fhV/8tVr3rVJT4Axw/GJzJpytsAAAAASUVORK5CYII="
    (testpath/"ocr.png").write ocr_png.unpack1("m")
    assert_match "Homebrew", shell_output("#{bin}/xberg extract ocr.png")

    doctor = JSON.parse(shell_output("#{bin}/xberg doctor --no-config-discovery --format json"))
    tesseract = doctor["checks"].find { |check| check["name"] == "ocr.tesseract" }
    assert_equal "pass", tesseract["status"]
  end
end
