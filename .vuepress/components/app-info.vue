<template>
	<div>
		<table class="info-table">
			<tr>
				<th>
					配置难度
				</th>
				<td>
					<n-rate
						readonly
						:allow-half="true"
						:value="difficulty"
					/>
				</td>
				<th>
					预计耗时
				</th>
				<td>{{ time }} 分钟</td>
			</tr>
		</table>
		<table
			v-if="access"
			class="access-table"
		>
			<thead>
				<tr>
					<th>
						隧道类型
					</th>
					<th>
						默认端口
					</th>
					<th>
						远程端口
					</th>
					<th v-if="access[0].method">
						访问方式
					</th>
				</tr>
			</thead>
			<tbody>
				<tr
					v-for="v in access"
					:key="v.proto"
				>
					<th>{{ v.proto }}</th>
					<td>{{ v.local }}</td>
					<td>{{ v.remote ?? '自定义' }}</td>
					<td v-if="v.method">
						{{ v.method }}
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</template>

<script setup lang="ts">
import { toRefs } from 'vue';
import { NRate } from 'naive-ui';

const props = defineProps<{
	time: number;
	difficulty: number;
	access?: {
		proto: string;
		local: string;
		remote?: string;
		method: string;
	}[];
}>();
const { time, difficulty } = toRefs(props);

</script>

<style lang="scss" scoped>
.info-table {
	th {
		background-color: var(--c-bg-light);
		transition: background-color var(--t-color);
	}
}

.access-table {
	tr {

		td:nth-child(2),
		td:nth-child(3) {
			text-align: center;
		}
	}
}
</style>