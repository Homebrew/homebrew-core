class Wazero < Formula
  desc "Zero dependency WebAssembly runtime"
  homepage "https://wazero.io"
  url "https://github.com/tetratelabs/wazero/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "9edaa4d7dba76cfe0f5b46a848065b8b0c97447c2cf3936b36daaff65d7ad758"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db845174006e3fd34e05a1d5f5f097e0828ee048343407dd8f8a52856183a00f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3147b904d79bfe43b6de6b315885aba02af416b7d1617046afe4c77af9a9d757"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7139fc1de92ab6ac4945eda7237882a60cc3c5f09c7e2d3c8b4c0df6d035ab38"
    sha256 cellar: :any_skip_relocation, sonoma:         "714fd6b2dd223a73ceaf75e3b1c5d52d8c36a2c23ee9b7a898bb883c49ea6832"
    sha256 cellar: :any_skip_relocation, ventura:        "94b03ef0f526ad0514fba550c02cd811bb015517bc4e4a3071077ffaeda553cc"
    sha256 cellar: :any_skip_relocation, monterey:       "9964a5b56fdc9cb5612ea05d1a32b28c0307e5bc3eac97b7921cdcd4cd7d01ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5bb1f736a02b3c615631d5e669da5ebd81ebd64c75079860b8dddf7c3b5bf37"
  end

  depends_on "go" => :build
  depends_on "wabt" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/tetratelabs/wazero/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/wazero"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/wazero version").chomp

    (testpath/"mount.wat").write <<~EOS
      ;; print the preopen directory path (guest side of the mount).
      (module
        (import "wasi_snapshot_preview1" "fd_prestat_get"
          (func $wasi.fd_prestat_get (param i32 i32) (result i32)))

        (import "wasi_snapshot_preview1" "fd_prestat_dir_name"
          (func $wasi.fd_prestat_dir_name (param i32 i32 i32) (result i32)))

        (import "wasi_snapshot_preview1" "fd_write"
          (func $wasi.fd_write (param i32 i32 i32 i32) (result i32)))

        (memory (export "memory") 1 1)

        (func $main (export "_start")
          ;; First, we need to know the size of the prestat dir name.
          (call $wasi.fd_prestat_get
            (i32.const 3) ;; preopen FD
            (i32.const 0)) ;; where to write prestat
          (drop) ;; ignore the errno returned

          ;; Next, write the dir name to offset 8 (past the prestat).
          (call $wasi.fd_prestat_dir_name
            (i32.const 3) ;; preopen FD
            (i32.const 8) ;; where to write dir_name
            (i32.load (i32.const 4))) ;; length is the last part of the prestat
          (drop) ;; ignore the errno returned

          ;; Now, convert the prestat to an iovec [offset, len] writing offset=8.
          (i32.store (i32.const 0) (i32.const 8))

          ;; Finally, copy the dirname to stdout via its iovec [offset, len].
          (call $wasi.fd_write
            (i32.const 1) ;; stdout
            (i32.const 0) ;; where's the iovec
            (i32.const 1) ;; only one iovec
            (i32.const 0)) ;; overwrite the iovec with the ignored result.
          (drop) ;; ignore the errno returned
        )
      )
    EOS

    system "wat2wasm", testpath/"mount.wat", "-o", testpath/"mount.wasm"

    assert_equal "/homebrew",
      shell_output("#{bin}/wazero run -mount=/tmp:/homebrew #{testpath/"mount.wasm"}")
  end
end
