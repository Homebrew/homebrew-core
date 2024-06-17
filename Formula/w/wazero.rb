class Wazero < Formula
  desc "Zero dependency WebAssembly runtime"
  homepage "https://wazero.io"
  url "https://github.com/tetratelabs/wazero/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "abc19b77acb6eec6a4abb33366a6b4be1ccf987496f424c64c41d90b016c4e51"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a27d2d462c556523f0d6f471a88515140040ba687e9d5a5028715f3729e12117"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d91a137ff4179e47f5c804a395bc9b5ae6a4794249adfdab08348ffd73c7f447"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb0381b7ba883a24a7aa869f208e113fefb848dba22c9fa6ad72a6b48fcce0cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "32d43543fb3920880eb9191433440583d65700c655d8108e19054ce319cf8a60"
    sha256 cellar: :any_skip_relocation, ventura:        "0645ca371ba79f1cace6b3e469dcb33815ddcb07be358f34cc466515b45fbccc"
    sha256 cellar: :any_skip_relocation, monterey:       "932b3ec2d41b437892679c789b1a0524e24d8029829b533a8170b1138c8905b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55903a92bbbdaf6eb3ef84b02a61971f819d1c39f9711125fe86bb83aa8c563f"
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
