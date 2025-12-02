class Wazero < Formula
  desc "Zero dependency WebAssembly runtime"
  homepage "https://wazero.io"
  url "https://github.com/tetratelabs/wazero/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "3f524d3fd1d89873d9e6f8d9591ea09e657bc855424f78754dbd074fa6804dd0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c034b27d88ad1bdcc29ea1c4fca0a3a19547ea6fe7d6a8086aa1968a6d7aff95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c034b27d88ad1bdcc29ea1c4fca0a3a19547ea6fe7d6a8086aa1968a6d7aff95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c034b27d88ad1bdcc29ea1c4fca0a3a19547ea6fe7d6a8086aa1968a6d7aff95"
    sha256 cellar: :any_skip_relocation, sonoma:        "01593a2f986c326dd399f466f5695c31d50422182ef91d7017fced166c7aebc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56110e6ca1d2837eac261f88ff7a0bd5fc06988ff48f7d99efe2c6b4d8d56fcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e755bc7fb0b2eaae390e6d0536c20064cf11bd009f778f02108ef78be6a048d"
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
