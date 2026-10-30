# SPEC §四「第十六期後仍保留的邊界」——分流、解法與執行順序

日期：2026-10-29 · 對象：`vv0101v01/golden`（cubical-hermitian）
基準：第十六期 `91fb5d2`，`116/116` 定理、`127` 條規格登記

---

## 0. 一句話答覆

**能解決一部分，而且「能」的定義要先分清楚。**

§四列了 7 條邊界，但它們混雜了三種性質完全不同的東西：

| 類別 | 性質 | 能不能「解決」 | 正確做法 |
|---|---|---|---|
| **A** | 定理禁止（NP-hard／不可判定／不在 `Q̄`） | **不能消除** | 收窄成可判定片斷 + 證書化 + 量化成數字 |
| **B** | 文獻已證、甚至已機械化 | **能**，是移植成本不是研究風險 | 照證明腳本移植 |
| **C** | 設計取捨（刻意不做的工程） | **能**，幾日內 | 直接補後端／開關 |

混淆三者是 §四目前最大的問題：它把「NP-hard」和「還沒寫的 POSIX 後端」並列成同一種「開放前沿」，
也把「Blakers–Massey」寫成未知——但它**早已在 HoTT-Agda 裡機械化完成**。

---

## 1. 逐項分流

### A 類：定理禁止（永久保留，但可收窄）

| §四條目 | 硬限制 | 出處 |
|---|---|---|
| Schema：Mahlo／超宇宙、一般高階索引容器 | 大基數公理不在有限層級核心的證明論強度內 | — |
| DSystem：稠密隨機圖極大團最壞情形 | NP-hard | 組合複雜度下界 |
| BDD：`n > 20` 單一無對稱不可分解函數的最佳 ROBDD 排序 | NP-hard | 現已誠實回報 `exact=false` |
| HOU：**二階以上**一般合一不可判定 | Goldfarb (1981) 二階不可判定（由 Hilbert 第十問題歸約）；Huet (1973)／Lucchesi (1972) 三階 | 已修正見 §2 |

**A 類的正確收斂動作（三件，都可做）：**

1. **降為可判定片斷並明確命名。** 例：HOU 的**匹配**（matching，單側無元變數）是**任意階可判定**的——
   二階 Huet–Lang (1978)、三階 Dowek (1992)、四階 Padovani (2000)、任意階 Stirling (2009)。
   本專案目前**沒有**這個片斷。補上後，HOU 邊界就能從「不可判定」精確收窄成
   「合一不可判定 / 匹配可判定且已實作完整判定程序」。
2. **邊界證書化（witness the reduction）。** 把不可判定性的歸約本身實作成程式：
   給一個 Diophantine 方程，產出一個二階合一問題，使「可合一 ⟺ 方程有解」。
   這樣「不可判定」就不再是一句引用，而是倉庫內一個可跑、可測的物件。
3. **把邊界量成數字。** 這套紀律本倉庫已經有範本：`docs/semiring/REPORT.md` §19
   「誠實的限制：每一個邊界都是一個量出來的數字」。把同一套套到 §4 自己身上，
   每條邊界附一個現場量出來的閾值（例如 ROBDD 的精確/非精確交叉點、BDD 對稱剪枝的 `n` 上界）。

### B 類：已知可證（純移植工程量）

| §四條目 | 真實狀態 | 規模估計 |
|---|---|---|
| 完整 1-連通 Blakers–Massey 推出定理（閉合 `π₂(S²) ≃ ℤ`、`π₃(S²) ≃ π₃(S³) ≃ ℤ`） | **已機械化**：Favonia–Finster–Licata–Lumsdaine, *A mechanization of the Blakers–Massey connectivity theorem in HoTT*, LICS'16（arXiv:1605.03227）。定理本體約 700 行 Agda | 2–4 週 |
| 撓率同倫群 `π₄(S³) ≃ ℤ/2ℤ` | **已機械化**：Brunerie 2016 博士論文給出合成證明；Ljungström–Mörtberg, *Formalising and Computing the Fourth Homotopy Group of the 3-Sphere in Cubical Agda*, LICS'23（arXiv:2302.00151）完整形式化，並把 Brunerie number 正規化到 `-2` | 2–3 個月 |
| `n ≥ 6` 結合多面體 `K_n` 「無限相干塔」 | **不是障礙**：Mac Lane 相干定理保證結合子圖表全交換，逐 `n` 構造即可；`K₅` 已做，往上推是機械性的 | ~1 週 |
| 有限居民切分由「項層級外延工具」提升為核心歸納規則 | 工程缺口，無理論障礙 | ~1 週 |

**B 類的做法**：本專案已有 `truncation.mbt`（propositional / set truncation）、
`univalence.mbt`、`sphere_homotopy.mbt`（73 KB，已有 Freudenthal／Hopf–Freudenthal／`π₂(S²)` 分裂收縮）
與 `dpath_*` 高階胞構造。積木基本齊備，缺的是 Blakers–Massey 的
`n-connected` / `is_connected` 分層與「餘極限方塊」的編碼——照 FFLL 的構造移植即可，
不需要新數學。

### C 類：設計取捨（偽邊界）

| §四條目 | 實況 |
|---|---|
| 持久層不直接耦合 POSIX `flock`／`mmap`／`fsync` 或網絡共識 | 刻意保持純函數抽象位元組協議（跨 `wasm-gc`／`native` 可重現）。這是**優點**，不是缺陷。要 closure 只需在既有協議下加一個原生後端，核心一行不用改 |
| 模組執行期熱載入 | 目前針對靜態非循環 DAG。熱載入是獨立增量，非理論障礙 |
| `5` 軸以上黑盒閉包須提升為 `CheckedDCube` | 純 API 使用問題，能力已存在 |

---

## 2. 本次對 SPEC 的兩處精確化（已改入 `SPEC.md`）

1. **Goldfarb 引述修正。** 原文寫「三階以上一般高階合一受 Goldfarb 定理限制本質不可判定」。
   Goldfarb (1981) 證明的是**二階**合一不可判定（由 Hilbert 第十問題歸約），比三階更強；
   Huet (1973)／Lucchesi (1972) 證三階。故「三階以上」應為「**二階以上**」。
   同時補上可閉合的相鄰地帶：匹配（matching）任意階可判定（Stirling 2009）。

2. **「開放前沿」的性質標注。** Blakers–Massey 與 `π₄(S³) ≃ ℤ/2ℤ` 不是研究問題，
   而是已完成機械化的結果；`K_n`（`n ≥ 6`）亦無「無限相干塔」障礙（Mac Lane 相干定理）。
   三者是移植成本，不是未知。

---

## 3. 已完成示範：把一條 A 類邊界變成可執行物件

選的是「精確代數 · 超越數不在 `Q̄` 內」。這是典型的 A 類：
`e ∉ Q̄` **永遠不可能**被消除——超越數無法用代數數呈現。
但它不因此就只能停留在散文：可以改成「**可認證**」。

新增 `algebra/transcendental.mbt`：

| 構造 | 性質 |
|---|---|
| `certified_e(n)` / `certified_pi(n)` | 嚴格有理包絡 `[lo, hi]`，攜帶可獨立複核的尾界 `tail`。`e` 用 `Σ1/k!` 尾界 `1/(n!·n)`；`π` 用 Machin 公式 + 交錯級數首省略項 |
| `e_irrationality_certificate(p, q)` | 對**每個** `q ≥ 1` 產出「`e ≠ p/q`」的否證證書。取 `M = N!`、`N ≥ max(q,2)`、`A = M·S_N ∈ ℤ`；由尾界得 `A < M·e < A+1`，而 `q | M` 會迫使 `M·e ∈ ℤ`，矛盾 |
| `e_irr_certificate_verify(c)` | 從儲存的見證**重新推導**每一條不等式；篡改 `a`、`m`、`n`、`q` 任一欄位必被拒 |
| `poly_nonzero_at_e` | Horner + 區間算術認證 `P(e) ≠ 0`；**可靠**，預算不足時如實回報「不排除」 |
| `pi_refute_rational_refined` | 逐步加密直到排除 `p/q`；預算不足時如實不宣稱 |

**哲學**：`e ∉ Q̄` 是關於**呈現**的不可能性；
「對任意 `p/q` 給出 `e ≠ p/q` 的可複核否證」是一個**全函數**。
後者把邊界從一句話變成一個可跑、可測、可否證的物件——
正是 `docs/semiring/REPORT.md` §19 那套紀律。

### 驗證結果

```text
moon check --deny-warn --target wasm-gc   ← 乾淨，零警告
moon test  --release   --target wasm-gc   ← Total tests: 15, passed: 15, failed: 0
moon run cmd/main      --release          ← passed 117/117   （原 116/116）
moon run cmd/showcase  --release          ← 42/42
moon info && python3 tools/audit_spec.py --check
                                          ← audit ok: 6524 symbols
```

規格登記 `127 → 128` 條（新增「超越數認證層」條目，含範形／範疇／判定三欄），
定理登記 `116 → 117` 項。

---

## 4. 建議執行順序（Phase 17 起）

按 value/effort 排序，每一期都是可獨立驗收的：

| 期 | 內容 | 類別 | 估計 |
|---|---|---|---|
| **17a** | C 類一次清：POSIX 後端（`flock`/`mmap`/`fsync`）＋模組熱載入，皆在既有抽象協議下增量 | C | ~1 週 |
| **17b** | 高階**匹配**判定程序（Stirling／Huet–Lang 片斷），閉合 HOU 邊界的可判定半邊；同時把 Goldfarb 歸約實作成邊界見證 | A | 1–2 週 |
| **17c** | `K_n`（`n ≥ 6`）結合多面體 ＋ 有限居民切分升為核心規則 | B | ~1 週 |
| **18** | Blakers–Massey 連通性（移植 FFLL），閉合 `π₂(S²) ≃ ℤ` 與 `π₃(S²) ≃ π₃(S³) ≃ ℤ` 的雙向同構 | B | 2–4 週 |
| **19** | `π₄(S³) ≃ ℤ/2ℤ`（Brunerie number + Gysin 序列；LICS'23 已有可參照的化簡路線） | B | 2–3 月 |
| 常設 | A 類四條永久保留，但每條都補上：可判定片斷名稱 + 邊界見證程式 + 現場量出的閾值數字 | A | 持續 |

---

## 4b. 第十七期 a 段：已完成

| 項目 | 檔案 | 狀態 |
|---|---|---|
| 模組執行期熱載入 | `module_hotload.mbt`（新增） | 完成 |
| 崩潰一致寫入協定 | `hostfs/durability.mbt`（新增套件 `hostfs`） | 完成 |
| 架構登記 | `architecture.json`、`hostfs_imports.mbt` | 完成 |

**熱載入**的核心是把「靜態 DAG」換成「帶一致性不變式的活環境」：
每個已安裝模組的依賴指紋必須等於實際安裝的介面雜湊。由此得到四態判決
`HotAdd`／`HotOpaqueSwap`／`HotRelink`／`HotReject`；替換後重新驗證不變式，
失敗則回滾至位元相同的舊環境，稽核日誌記錄每次嘗試（含回滾）。

**崩潰一致寫入**的關鍵是區分兩種耐久性——內容耐久（fsync 檔案）與目錄項耐久（fsync 父目錄）。
撕裂讀正是兩者次序顛倒時「名稱指向未落盤 inode」的現象。協定
`lock → write(staging) → fsync(staging) → rename → fsync(dir) → unlock`
在**每一個**崩潰點上只回舊值或新值；漏掉檔案 fsync 的協定在第 4 個崩潰點被精確偵測為撕裂；
漏掉目錄 fsync 的協定安全但如實判定為未承認寫入。模型純 MoonBit，故 `wasm-gc` 上亦可驗證。

回歸：`moon check --deny-warn` 乾淨 · `moon test` 15/15 ·
`cmd/main` **119/119** · `audit_spec` 6614 symbols · `arch_check` 無失敗。

## 5. 結論

- **A 類（4 條）不會消失**，但可以且應該從「散文」升級為「證書 + 數字 + 可判定片斷」。
- **B 類（4 條）是真的能解決**，而且不需要新數學——文獻已有機械化證明可供移植。
- **C 類（3 條）本質上不是邊界**，是尚未做的工程取捨，幾日內可清。
- 本次已示範第一條收束（`algebra/transcendental.mbt`），全倉回歸乾淨。

真正該改的，是 §四的**寫法**：把「開放前沿」拆成
「不可消除 / 可移植 / 未施作」三欄，每欄附上量出來的數字或可跑的程式，
而不是把 NP-hard、大基數公理和「還沒寫的 `mmap` 後端」放在同一個清單裡。

## 4c 第十七期 b 段：已完成

| 項目 | 結果 |
|---|---|
| 交付物 | `hou_match.mbt`（根套件，新元件 `hou-match`，layer 5，依賴 `frontend`） |
| 片斷 | 單側匹配 `?F t̄ == u`，右側與脊柱皆無元變數 |
| 相異變數脊柱 | 解唯一，直接構造，**無需界限**（代入 `?F:=λx̄.M` 於 `(?F x̄)` 直接得 `M`） |
| 一般脊柱 | 有界列舉 + **βη 轉換重新驗證**每個候選解 |
| 聲音性 | 無條件：回傳前必經驗證，`hou_conv` 自身有 β、η 與反向否例測試 |
| 完整性 | 相異變數脊柱無條件；其餘情形為「列舉空間內」，`NoneWithinBound(b)` 永不等同「無解」 |
| 範圍限制（如實） | body 不含內部 λ，故脊柱後結果型別須為一階 |
| 回歸 | `moon check --deny-warn` 0 warnings · `moon test --release` 全綠 · `cmd/main` **120/120** · `audit_spec.py --check` ok 於 **6625** 符號 · `arch_check.py` 0 failures · 登記表 **131** 條 |

修復歷程（debug 記錄）：(1) `meta_id` guard 令 fresh unifier 上未註冊的 meta 一律被拒——測試改以 `hou_fresh_meta` 建立真 meta；(2) 單變數脊柱亦屬相異變數脊柱、走快速路徑，故「bound 不足」的誠實性測試必須改用**重複**脊柱；(3) body 尺寸量度為 `size(UApp(f,a)) = 1 + size(f) + size(a)`，`f(f(f x))` 為 7 而非 5，界限測試據此修正。

## 4d 第十七期 c 段：已完成

| 項目 | 結果 |
|---|---|
| 交付物 | `associahedron.mbt`（根套件，新元件 `associahedron`，layer 5，依賴 `foundation`＋`dependent-kernel`＋`cubical`） |
| 範圍 | 任意 n 的 Stasheff 結合多面體 `K_n`，已驗證 n = 3..9（含 `n ≥ 6` 前沿） |
| 模型 | 面格 = n 片葉無一元節點的平面樹（Schröder 樹）；dim = Σ(arity−2) |
| 二維面性質 | 五邊形／正方形在此模型下是**計算**而非斷言：維度 2 只能來自 1 個 arity-4 節點（5 頂點）或 2 個 arity-3 節點（4 頂點） |
| 對帳 | Tamari 旋轉圖邊數 = 面格 f_1（兩個模型獨立吻合） |
| 不變量 | f_0 = Catalan(n−1)、f_1 = (n−2)f_0/2、facet = n(n−1)/2−1、Σ(−1)^k f_k = 1、1-骨架連通 |
| 剩餘邊界 | 立方 n-胞填充器受 `dpath_singleton5_transport_value`（固定 5 階）限制，缺 n 階 singleton transport |
| 回歸 | `moon check --deny-warn` 0 warnings · `moon test --release` 15/15 · `cmd/main` **121/121** · `audit_spec.py --check` ok · `arch_check.py` 0 failures · 登記表 **132** 條 |

修復歷程：facet 是 `f[n−3]` 而非 `f[n−2]`（`f[top]` 恆為 1，是多面體自身）；`paren_all` 原本產生子樹內局部葉編號，令 `paren_k5_lhs1()` 匹配唔到 K₅ 頂點，已加全域重編號。

## 4e 第十八期：已完成（Blakers–Massey 與 Freudenthal）

| 項目 | 結果 |
|---|---|
| 交付物 | `blakers_massey.mbt`（根套件，新元件 `blakers-massey`，layer 5，自包含無外部符號依賴） |
| **已證明**（可執行） | 連接度算術 `gap(m,n)=m+n`；由間隙**推導** Freudenthal 穩定範圍；有限生成交換群上的恰當序列代數；Hopf 纖維序列 LES；`π₃(S²) ≃ π₃(S³)`、`π₃(S³) ≃ π₂(S²)` |
| **已 import**（未自證） | Blakers–Massey 連通性定理本體；`π₂(S²) ≃ ℤ` 的滿射半邊（`σ ∘ ∂_Hopf = id`） |
| 來源鏈 | 每個結果附 `Origin` 陣列（`Proved` / `Prior` / `Imported`），可見於答案，絕不隱藏 |
| 對帳 | Freudenthal 預測逐例核對已知群：π₁(S¹)=ℤ、π₂(S²)=ℤ、π₃(S³)=ℤ、π₃(S²)=ℤ、π₄(S³)=ℤ/2、π₂(S³)=0、π₁(S²)=0 |
| 剩餘移植成本 | 缺 join 與 join–wedge 連接度引理、n-截斷型別構造子與遞迴原理、一般 n 的 `WedgeConnectivity`（現僅有圓的 `wedge_connectivity_circle_*`） |
| 回歸 | `moon check --deny-warn` 0 warnings · `moon test --release` · `cmd/main` **122/122** · `audit_spec.py --check` ok 於 **6505** 符號 · `arch_check.py` 0 failures · 登記表 **133** 條 |

推導鏈（可檢查）：X 為 n-連通 ⟹ `X→1` 為 (n+1)-連通 ⟹ ΣX 推出方塊兩臂皆 (n+1)-連通 ⟹ 間隙 `bm_gap(n+1,n+1) = 2n+2` 連通 ⟹ `gap_equiv_below(2n+2) = 2n`、`gap_surj_at(2n+2) = 2n+1`。

## 4f 第十九期：已完成（Brunerie 數與 `π₄(S³) ≃ ℤ/2ℤ`）

| 項目 | 結果 |
|---|---|
| 交付物 | `brunerie_pi4_s3.mbt`（根套件，元件 `brunerie-pi4-s3`，layer 5，依賴 `blakers-massey`） |
| 證明結構 | `β = ψ[i₂, i₂]`（Brunerie 定義 4.11）；推論 4.12 `π₄(S³) ≃ ℤ/βℤ`；故歸結為 β 能否 normalize 至 ±2 |
| **已證明**（可執行） | join 維度 `S^m*S^n ≃ S^(m+n+1)`（⟹ `S¹*S¹ ≃ S³`）；Whitehead 次數 `[α,β] ∈ π_{p+q−1}`（⟹ `[i₂,i₂] ∈ π₃(S²)`，與第十八期 ψ 定義域一致）；`J(S^n)` 胞結構；Hopf LES `π₄(S³) ≃ π₄(S²)`（複用 `hopf_les_iso`）；`ℤ/βℤ` 算術含退化情形；定理 6.17 判準 `|n|=2`；β₁·β₂·β₃ 複雜度嚴格遞減 |
| **已 import** | James 構造、Whitehead 積、`π₄(S³) ≃ ℤ/βℤ` 同構、β₃ 優化版 normalize 至 −2 嘅計算 |
| 來源鏈 | 10 項：Proved 5、Prior 1、Imported 4 —— **比例由測試斷言**，唔係註解入面講吓 |
| 量度門檻 | Brunerie 原證明 ~9000 LOC 而 β 無法計算；直接計算 β ~600 LOC；優化版 β₃ 約 4 秒得 −2；β₁、β₂ 無法在合理時間內 normalize |
| 回歸 | `moon check --deny-warn` 0 warnings · `moon test --release` · `cmd/main` **123/123** · `audit_spec.py --check` ok 於 **6534** 符號 · `arch_check.py` 0 failures · 登記表 **134** 條 |

跨期對帳（重要）：Whitehead 積把 `[i₂,i₂]` 放進 `π₃(S²)`，而第十八期獨立證明咗 `π₃(S²) ≃ ℤ` —— 兩期自己對得上，`ψ` 嘅定義域唔係靠我手寫假設。

## 4g 第二十期 a 段：已完成（通用同倫型別構造子）

| 項目 | 結果 |
|---|---|
| 交付物 | `homotopy_universal.mbt`（根套件，元件 `homotopy-universal`，layer 5，依賴 `cubical` / `foundation` / `finite-cubical` / `dependent-kernel` / `exact-algebra`） |
| 做法 | 四個型別構造子全部以本庫既有嘅 `DHitSpec` 機制宣告為**真正嘅 HIT**，而唔係對 HIT 嘅描述；遞迴原則由 `eval_hit_elim` 構造 |
| **已證明**（可執行） | join 遞迴喺 `inl`、`inr` 及 `push` 兩個端點嘅計算規則；wedge 遞迴喺兩個點構造子，且 `wglue 0 = winl a0`、`wglue 1 = winr b0`；James 嘅 fold 喺 `nil`；截斷遞迴喺 `inc`；`dim(A*B) = dim A + dim B + 1`（⟹ `S^m*S^n ≃ S^(m+n+1)`）；`J(S^n)` 在 `0,n,2n,…` 各一胞 |
| **未能編碼**（如實） | 截斷嘅 hub-and-spoke 高階構造子、James 嘅單位關係 `cons a0 x = x` —— 兩者都要求一條**端點係裸約束變數**嘅路徑，而 `dhit_face` 只能表達「構造子索引加參數」；截斷嘅 `hub` 值域仲要提及自身型別 |
| **仍然 import**（7 項） | join–wedge 連接度引理、一般 n 嘅 `WedgeConnectivity`、Blakers–Massey codes 構造、Whitehead 積貼附映射、定理 4.9、推論 4.12，加上上面兩項未能編碼嘅構造子 —— 全部由 `homotopy_universal_remaining()` 列出，測試斷言其數目 |
| 關鍵約定（踩坑記錄） | `DHitSpec` 嘅 de Bruijn scope 係**最近綁定者排最前**：cell 參數類型同 face 都用同一個 scope；face 入面 `DTVar(k)` 索引 `[細胞參數（逆序）…, params（逆序）]`。呢點由既有 `quotient_schema` 反推確定（`related : DApp(DApp(DTVar(2), DTVar(1)), DTVar(0))` 逐位對得上） |
| 回歸 | `moon check --deny-warn` 0 warnings · `moon test --release` **15/15** · `cmd/main` **124/124** · `audit_spec.py --check` ok 於 **6564** 符號 · `arch_check.py` 0 failures · 登記表 **135** 條 |

範圍聲明：本段**收窄**咗第十八、十九期嘅移植缺口，而**冇閂埋**佢。有咗型別構造子只係前置條件，唔係替代品 —— 連接度引理本身仍然係 import，`homotopy_universal_remaining()` 就係為咗令呢句說話可以俾測試檢查，而唔係淨係寫喺註解度。
