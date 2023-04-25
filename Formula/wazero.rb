class Wazero < Formula
  desc "Zero dependency WebAssembly runtime"
  homepage "https://wazero.io"
  url "https://github.com/tetratelabs/wazero/archive/v1.0.3.tar.gz"
  sha256 "d83f71e6a30b5097b70c550a5ad0317a00849b401206bab89ee7226809b481c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08bd24a3a3162faf6cbc18bf11526e800a077098b26bbca2fd0a84a85cfbc06b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08bd24a3a3162faf6cbc18bf11526e800a077098b26bbca2fd0a84a85cfbc06b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08bd24a3a3162faf6cbc18bf11526e800a077098b26bbca2fd0a84a85cfbc06b"
    sha256 cellar: :any_skip_relocation, ventura:        "f2a9b7f900638c82c56c257ae674d8fbc2b87bb3d11779d806ea28d4b9d646cf"
    sha256 cellar: :any_skip_relocation, monterey:       "f2a9b7f900638c82c56c257ae674d8fbc2b87bb3d11779d806ea28d4b9d646cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2a9b7f900638c82c56c257ae674d8fbc2b87bb3d11779d806ea28d4b9d646cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48fab2eb4e93103fbe47af04f37ca0d09e7ce3d99336805e893cf33d53ece5ad"
  end

  depends_on "go" => :build
  depends_on "wabt" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/tetratelabs/wazero/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/wazero"
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
