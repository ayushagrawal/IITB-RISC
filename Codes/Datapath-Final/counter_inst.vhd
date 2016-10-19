counter_inst : counter PORT MAP (
		aclr	 => aclr_sig,
		clock	 => clock_sig,
		cnt_en	 => cnt_en_sig,
		q	 => q_sig
	);
